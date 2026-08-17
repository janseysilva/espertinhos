import 'package:flutter_tts/flutter_tts.dart';

/// Lê em voz alta as instruções de cada fase — usado só na faixa de 2 a 4
/// anos, já que essas crianças ainda não sabem ler e algumas ainda não
/// conhecem bem cores/objetos. Voz mais devagar e um pouco mais aguda,
/// pensada pra criança pequena entender fácil.
class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _ready = false;

  Future<void> _ensureReady() async {
    if (_ready) return;
    _ready = true;
    try {
      await _tts.setLanguage('pt-BR');
      await _tts.setSpeechRate(0.42);
      await _tts.setPitch(1.15);
      await _tts.awaitSpeakCompletion(true);
    } catch (_) {
      // Sem motor de TTS disponível no aparelho — não é fatal, só fica mudo.
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
