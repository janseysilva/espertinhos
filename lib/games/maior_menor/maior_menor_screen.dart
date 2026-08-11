import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/age_group.dart';
import '../../widgets/choice_game_scaffold.dart';

class MaiorMenorScreen extends StatelessWidget {
  const MaiorMenorScreen({super.key, required this.age});

  final AgeGroup age;

  @override
  Widget build(BuildContext context) {
    final maxN = switch (age.level) { 0 => 10, 1 => 30, _ => 100 };

    return ChoiceGameScreen(
      gameId: 'maior_menor',
      title: 'Maior ou Menor',
      totalRounds: 8,
      gridCrossAxisCount: 2,
      optionAspectRatio: 1.3,
      roundGenerator: (round) {
        final random = Random();
        final askBigger = round.isEven;
        var a = 1 + random.nextInt(maxN);
        var b = 1 + random.nextInt(maxN);
        while (b == a) {
          b = 1 + random.nextInt(maxN);
        }
        final correct = askBigger ? max(a, b) : min(a, b);

        return RoundData(
          prompt: Text(
            askBigger ? 'Toque no número MAIOR' : 'Toque no número MENOR',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          options: [a, b]
              .map(
                (n) => ChoiceOption(
                  isCorrect: n == correct,
                  child: Text('$n', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w800)),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
