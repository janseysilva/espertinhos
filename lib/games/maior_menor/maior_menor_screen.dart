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
    // Guarda os pares de números já perguntados nessa partida, pra nunca
    // repetir a mesma dupla em rodadas diferentes.
    final usedPairs = <(int, int)>{};

    return ChoiceGameScreen(
      gameId: 'maior_menor',
      title: 'Maior ou Menor',
      totalRounds: age.starsToAdvance,
      gridCrossAxisCount: 2,
      optionAspectRatio: 1.3,
      roundGenerator: (round) {
        if (round == 0) usedPairs.clear();
        final random = Random();
        final askBigger = round.isEven;
        int a, b;
        do {
          a = 1 + random.nextInt(maxN);
          b = 1 + random.nextInt(maxN);
          while (b == a) {
            b = 1 + random.nextInt(maxN);
          }
        } while (usedPairs.contains((min(a, b), max(a, b))));
        usedPairs.add((min(a, b), max(a, b)));
        final correct = askBigger ? max(a, b) : min(a, b);

        final text = askBigger ? 'Toque no número MAIOR' : 'Toque no número MENOR';
        return RoundData(
          prompt: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          promptText: text,
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
