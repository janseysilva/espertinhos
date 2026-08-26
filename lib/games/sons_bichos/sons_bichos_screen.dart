import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/age_group.dart';
import '../../models/scoring.dart';
import '../../services/music_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_background.dart';
import '../../widgets/end_game_dialog.dart';
import '../../widgets/feedback_flash.dart';
import '../../widgets/game_top_bar.dart';
import '../../widgets/squishy_button.dart';

enum _Animal { cachorro, gato, vaca, pato, galo, leao, cavalo, ovelha, porco, elefante }

const _animalEmoji = {
  _Animal.cachorro: '🐶',
  _Animal.gato: '🐱',
  _Animal.vaca: '🐄',
  _Animal.pato: '🦆',
  _Animal.galo: '🐓',
  _Animal.leao: '🦁',
  _Animal.cavalo: '🐴',
  _Animal.ovelha: '🐑',
  _Animal.porco: '🐷',
  _Animal.elefante: '🐘',
};

const _animalNames = {
  _Animal.cachorro: 'Cachorro',
  _Animal.gato: 'Gato',
  _Animal.vaca: 'Vaca',
  _Animal.pato: 'Pato',
  _Animal.galo: 'Galo',
  _Animal.leao: 'Leão',
  _Animal.cavalo: 'Cavalo',
  _Animal.ovelha: 'Ovelha',
  _Animal.porco: 'Porco',
  _Animal.elefante: 'Elefante',
};

const _animalAsset = {
  _Animal.cachorro: 'audio/animais/cachorro.mp3',
  _Animal.gato: 'audio/animais/gato.mp3',
  _Animal.vaca: 'audio/animais/vaca.mp3',
  _Animal.pato: 'audio/animais/pato.mp3',
  _Animal.galo: 'audio/animais/galo.mp3',
  _Animal.leao: 'audio/animais/leao.mp3',
  _Animal.cavalo: 'audio/animais/cavalo.mp3',
  _Animal.ovelha: 'audio/animais/ovelha.mp3',
  _Animal.porco: 'audio/animais/porco.mp3',
  _Animal.elefante: 'audio/animais/elefante.mp3',
};

class SonsBichosScreen extends StatefulWidget {
  const SonsBichosScreen({super.key, required this.age});

  final AgeGroup age;

  @override
  State<SonsBichosScreen> createState() => _SonsBichosScreenState();
}

class _SonsBichosScreenState extends State<SonsBichosScreen> {
  final AudioPlayer _sfxPlayer = AudioPlayer();
  late List<_Animal> pool;
  late int optionCount;
  late int totalRounds;
  int round = 0;
  int mistakes = 0;
  bool? feedback;
  bool locked = false;
  late _Animal target;
  late List<_Animal> options;

  @override
  void initState() {
    super.initState();
    final animalCount = switch (widget.age.level) { 0 => 4, 1 => 7, _ => 10 };
    optionCount = switch (widget.age.level) { 0 => 4, 1 => 6, _ => 8 };
    pool = _Animal.values.take(animalCount).toList();
    totalRounds = widget.age.starsToAdvance;
    _newRound();
  }

  @override
  void dispose() {
    _sfxPlayer.dispose();
    super.dispose();
  }

  void _newRound() {
    final random = Random();
    target = pool[random.nextInt(pool.length)];
    final chosen = <_Animal>{target};
    while (chosen.length < optionCount && chosen.length < pool.length) {
      chosen.add(pool[random.nextInt(pool.length)]);
    }
    options = chosen.toList()..shuffle(random);
    _playSound();
  }

  Future<void> _playSound() async {
    if (context.read<MusicService>().muted) return;
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.play(AssetSource(_animalAsset[target]!));
    } catch (_) {
      // Sem áudio disponível — não trava o jogo.
    }
  }

  void _restart() {
    setState(() {
      round = 0;
      mistakes = 0;
      feedback = null;
      locked = false;
      _newRound();
    });
  }

  Future<void> _answer(_Animal picked) async {
    if (locked) return;
    locked = true;
    final correct = picked == target;
    if (!correct) mistakes++;
    setState(() => feedback = correct);
    await Future.delayed(const Duration(milliseconds: 550));
    if (!mounted) return;
    if (round + 1 >= totalRounds) {
      final stars = starsFromRounds(totalRounds, mistakes);
      setState(() => feedback = null);
      await showEndGameDialog(
        context,
        gameId: 'sons_bichos',
        stars: stars,
        maxStars: totalRounds,
        onReplay: _restart,
      );
    } else {
      setState(() {
        round++;
        feedback = null;
        locked = false;
        _newRound();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  children: [
                    GameTopBar(
                      progressLabel: '${(round + 1).clamp(1, totalRounds)} / $totalRounds',
                      progress: (round + 1) / totalRounds,
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Que bicho fez esse som?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black26, offset: Offset(0, 2))],
                      ),
                    ),
                    const SizedBox(height: 14),
                    SquishyButton(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: 999,
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                      onTap: _playSound,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.volume_up_rounded, color: AppColors.accent, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Ouvir de novo',
                            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.accent, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: optionCount <= 4 ? 2 : 3,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.1,
                        ),
                        itemCount: options.length,
                        itemBuilder: (context, i) {
                          final animal = options[i];
                          return SquishyButton(
                            borderRadius: 20,
                            onTap: () => _answer(animal),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(_animalEmoji[animal]!, style: const TextStyle(fontSize: 40)),
                                  const SizedBox(height: 6),
                                  Text(
                                    _animalNames[animal]!,
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              FeedbackFlash(correct: feedback),
            ],
          ),
        ),
      ),
    );
  }
}
