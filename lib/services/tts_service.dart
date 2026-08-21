import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _voiceNameKey = 'ttsVoiceName';
const _voiceLocaleKey = 'ttsVoiceLocale';

/// Lê em voz alta as instruções de cada fase, em todos os 12 jogos e
/// faixas etárias. Voz mais devagar e um pouco mais aguda por padrão,
/// pensada pra criança pequena entender fácil — mas o adulto pode trocar
/// pela voz que preferir em "🗣️ Voz" na tela inicial, escolhendo entre as
/// vozes em português instaladas no aparelho (varia por celular).
class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _ready = false;
  Map<String, String>? _selectedVoice;

  Map<String, String>? get selectedVoice => _selectedVoice;

  Future<void> _ensureReady() async {
    if (_ready) return;
    _ready = true;
    try {
      await _tts.setLanguage('pt-BR');
      await _tts.setSpeechRate(0.42);
      await _tts.setPitch(1.15);
      await _tts.awaitSpeakCompletion(true);
      await _loadSavedVoice();
    } catch (_) {
      // Sem motor de TTS disponível no aparelho — não é fatal, só fica mudo.
    }
  }

  Future<void> _loadSavedVoice() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_voiceNameKey);
    final locale = prefs.getString(_voiceLocaleKey);
    if (name == null || locale == null) return;
    _selectedVoice = {'name': name, 'locale': locale};
    try {
      await _tts.setVoice(_selectedVoice!);
    } catch (_) {
      // A voz salva pode não existir mais nesse aparelho — segue com a
      // voz padrão do sistema em vez de travar.
    }
  }

  /// Lista as vozes em português instaladas no aparelho — varia por
  /// fabricante/versão do Android, por isso não dá pra saber de antemão
  /// quais existem; o app pergunta direto pro sistema.
  Future<List<Map<String, String>>> listPortugueseVoices() async {
    await _ensureReady();
    try {
      final raw = await _tts.getVoices;
      final voices = <Map<String, String>>[];
      for (final v in (raw as List)) {
        if (v is Map) {
          final name = v['name']?.toString();
          final locale = v['locale']?.toString();
          if (name != null && locale != null && locale.toLowerCase().startsWith('pt')) {
            voices.add({'name': name, 'locale': locale});
          }
        }
      }
      voices.sort((a, b) => a['name']!.compareTo(b['name']!));
      return voices;
    } catch (_) {
      return [];
    }
  }

  /// Troca a voz usada (ou volta pra padrão do aparelho se [voice] for
  /// nulo) e lembra a escolha pra próxima vez que o app abrir.
  Future<void> setPreferredVoice(Map<String, String>? voice) async {
    await _ensureReady();
    _selectedVoice = voice;
    final prefs = await SharedPreferences.getInstance();
    if (voice == null) {
      await prefs.remove(_voiceNameKey);
      await prefs.remove(_voiceLocaleKey);
    } else {
      try {
        await _tts.setVoice(voice);
      } catch (_) {}
      await prefs.setString(_voiceNameKey, voice['name']!);
      await prefs.setString(_voiceLocaleKey, voice['locale']!);
    }
  }

  Future<void> speak(String text) async {
    await _ensureReady();
    try {
      await _tts.stop();
      await _tts.speak(text);
    } catch (_) {
      // Ignora falha de fala — o texto na tela continua funcionando normal.
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }
}
