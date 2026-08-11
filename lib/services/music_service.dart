import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _mutedPrefKey = 'musicMuted';
const _musicVolume = 0.28;

const _tracks = ['audio/musica1.wav', 'audio/musica2.wav', 'audio/musica3.wav'];

/// Música de fundo com 3 melodias que se alternam (pra não enjoar), com
/// preferência de mudo salva no aparelho — mesma ideia da versão HTML
/// (melodias curtas geradas por código, botão de mutar fixo na tela).
class MusicService extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  bool muted = false;
  bool _started = false;
  int _trackIndex = 0;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    muted = prefs.getBool(_mutedPrefKey) ?? false;
    await _player.setReleaseMode(ReleaseMode.release);
    await _player.setVolume(muted ? 0 : _musicVolume);
    _player.onPlayerComplete.listen((_) => _playNext());
    notifyListeners();
  }

  Future<void> start() async {
    if (_started) return;
    _started = true;
    _trackIndex = Random().nextInt(_tracks.length);
    await _playCurrent();
  }

  Future<void> _playCurrent() async {
    try {
      await _player.play(AssetSource(_tracks[_trackIndex]));
    } catch (_) {
      // Sem áudio disponível (ex: rodando em ambiente sem saída de som) — não é fatal.
    }
  }

  Future<void> _playNext() async {
    _trackIndex = (_trackIndex + 1) % _tracks.length;
    await _playCurrent();
  }

  Future<void> toggleMute() async {
    muted = !muted;
    notifyListeners();
    await _player.setVolume(muted ? 0 : _musicVolume);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_mutedPrefKey, muted);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
