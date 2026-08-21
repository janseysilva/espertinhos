import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/age_group.dart';
import '../../widgets/choice_game_scaffold.dart';

const _iconPool = [
  '🐶', '🐱', '🐭', '🦊', '🐻', '🐼', '🐨', '🐯', '🦁', '🐷',
  '🍎', '🍌', '🍇', '🍉', '🍓', '⭐', '🌙', '☀️', '🌸', '🍀',
];

class AcheDiferenteScreen extends StatelessWidget {
  const AcheDiferenteScreen({super.key, required this.age});

  final AgeGroup age;

  @override
  Widget build(BuildContext context) {
    final gridSize = switch (age.level) { 0 => 6, 1 => 9, _ => 12 };
    final crossAxisCount = switch (age.level) { 0 => 3, 1 => 3, _ => 4 };

    return ChoiceGameScreen(
      gameId: 'ache_diferente',
      title: 'Ache o Diferente',
      totalRounds: age.starsToAdvance,
      gridCrossAxisCount: crossAxisCount,
      optionAspectRatio: 1.0,
      roundGenerator: (round) {
        final random = Random();
        final base = _iconPool[random.nextInt(_iconPool.length)];
        String diff;
        do {
          diff = _iconPool[random.nextInt(_iconPool.length)];
        } while (diff == base);
        final oddIndex = random.nextInt(gridSize);

        return RoundData(
          prompt: const Text(
            'Toque no que é diferente',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          promptText: 'Toque no que é diferente',
          options: List.generate(
            gridSize,
            (i) => ChoiceOption(
              isCorrect: i == oddIndex,
              child: Text(i == oddIndex ? diff : base, style: const TextStyle(fontSize: 34)),
            ),
          ),
        );
      },
    );
  }
}
