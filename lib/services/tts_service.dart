import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _voiceNameKey = 'ttsVoiceName';
const _voiceLocaleKey = 'ttsVoiceLocale';
const _engineKey = 'ttsEngine';

/// Lê em voz alta as instruções de cada fase, em todos os 12 jogos e
/// faixas etárias. Voz mais devagar e um pouco mais aguda por padrão,
/// pensada pra criança pequena entender fácil — mas o adulto pode trocar
/// pela voz que preferir em "🗣️ Voz" na tela inicial, escolhendo entre as
/// vozes em português instaladas no aparelho (varia por celular).
class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _ready = false;
  Map<String, String>? _selectedVoice;
  String? _selectedEngine;

  Map<String, String>? get selectedVoice => _selectedVoice;
  String? get selectedEngine => _selectedEngine;

  /// Prepara o motor de TTS assim que o app abre, em vez de deixar pra
  /// primeira fala de verdade — sem isso, a fala da fase 1 demorava alguns
  /// segundos "sincronizando" (era o setup do motor rodando pela primeira
  /// vez bem na hora em que a criança já esperava ouvir o comando).
  Future<void> warmUp() => _ensureReady();

  Future<void> _ensureReady() async {
    if (_ready) return;
    _ready = true;
    try {
      await _loadSavedEngine();
      await _tts.setLanguage('pt-BR');
      await _tts.setSpeechRate(0.42);
      await _tts.setPitch(1.15);
      await _tts.awaitSpeakCompletion(true);
      await _loadSavedVoice();
    } catch (_) {
      // Sem motor de TTS disponível no aparelho — não é fatal, só fica mudo.
    }
  }

  Future<void> _loadSavedEngine() async {
    final prefs = await SharedPreferences.getInstance();
    final engine = prefs.getString(_engineKey);
    if (engine == null) return;
    _selectedEngine = engine;
    try {
      await _tts.setEngine(engine);
    } catch (_) {
      // Motor salvo pode ter sido desinstalado — segue com o padrão.
    }
  }

  /// Lista os motores de fala (apps) instalados no aparelho — alguns
  /// celulares vêm com mais de um (ex: Google, do fabricante), cada um com
  /// seu próprio conjunto de vozes. Trocar de motor é o jeito de ter vozes
  /// de verdade diferentes, além das do motor padrão.
  Future<List<String>> listEngines() async {
    await _ensureReady();
    try {
      final raw = await _tts.getEngines;
      return List<String>.from(raw as List);
    } catch (_) {
      return [];
    }
  }

  /// Troca o motor de fala (ou volta pro padrão do aparelho se [engine] for
  /// nulo). Como as vozes de um motor não existem no outro, a voz
  /// selecionada é resetada pra padrão ao trocar.
  Future<void> setPreferredEngine(String? engine) async {
    await _ensureReady();
    _selectedEngine = engine;
    final prefs = await SharedPreferences.getInstance();
    if (engine == null) {
      await prefs.remove(_engineKey);
    } else {
      try {
        await _tts.setEngine(engine);
        await _tts.setLanguage('pt-BR');
        await _tts.setSpeechRate(0.42);
        await _tts.setPitch(1.15);
      } catch (_) {}
      await prefs.setString(_engineKey, engine);
    }
    await setPreferredVoice(null);
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

  /// Lista as vozes em português BRASILEIRO instaladas no aparelho — varia
  /// por fabricante/versão do Android, por isso não dá pra saber de
  /// antemão quais existem; o app pergunta direto pro sistema. Fica de
  /// fora qualquer voz de outro português (ex: Portugal), pra não confundir
  /// a criança com uma pronúncia diferente da que ela conhece.
  ///
  /// Motores como o do Google costumam listar a MESMA pessoa/voz duas vezes
  /// — uma versão "-local" (funciona offline) e uma "-network" (precisa de
  /// internet, geralmente mais natural) — o que parecia "voz repetida" pra
  /// quem tá escolhendo. Aqui elas são agrupadas como uma coisa só,
  /// preferindo a "-local" (funciona sem internet, mais confiável pra
  /// criança no meio de um jogo).
  Future<List<Map<String, String>>> listPortugueseVoices() async {
    await _ensureReady();
    try {
      final raw = await _tts.getVoices;
      final byGroup = <String, Map<String, String>>{};
      for (final v in (raw as List)) {
        if (v is! Map) continue;
        final name = v['name']?.toString();
        final locale = v['locale']?.toString();
        final normalizedLocale = locale?.toLowerCase().replaceAll('_', '-');
        if (name == null || normalizedLocale == null || !normalizedLocale.startsWith('pt-br')) {
          continue;
        }
        final match = RegExp(r'^(.*?)-(local|network)$', caseSensitive: false).firstMatch(name);
        final groupKey = (match?.group(1) ?? name).toLowerCase();
        final quality = match?.group(2)?.toLowerCase();
        final existing = byGroup[groupKey];
        // Se já tem uma versão desse grupo guardada, só troca se a nova for
        // "local" e a guardada não for (senão mantém a primeira encontrada).
        final existingIsLocal = existing != null &&
            RegExp(r'-local$', caseSensitive: false).hasMatch(existing['name']!);
        if (existing == null || (quality == 'local' && !existingIsLocal)) {
          byGroup[groupKey] = {'name': name, 'locale': locale!};
        }
      }
      final voices = byGroup.values.toList()..sort((a, b) => a['name']!.compareTo(b['name']!));
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
