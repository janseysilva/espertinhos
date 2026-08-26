import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/age_group.dart';
import '../../widgets/choice_game_scaffold.dart';

const _objects = ['🍎', '🍓', '🐟', '⭐', '🐠', '🍌', '🎈', '🦋'];

class ContandoScreen extends StatelessWidget {
  const ContandoScreen({super.key, required this.age});

  final AgeGroup age;

  @override
  Widget build(BuildContext context) {
    final (minN, maxN) = switch (age.level) {
      0 => (1, 5),
      1 => (4, 9),
      _ => (10, 20),
    };
    final totalRounds = age.starsToAdvance;
    // Sorteia a sequência de números da partida inteira de uma vez só (sem
    // repetir nenhum), em vez de sortear rodada por rodada — evita que a
    // mesma contagem apareça duas vezes na mesma partida.
    List<int>? roundTargets;

    return ChoiceGameScreen(
      gameId: 'contando',
      title: 'Contando',
      totalRounds: totalRounds,
      gridCrossAxisCount: 3,
      optionAspectRatio: 1.0,
      roundGenerator: (round) {
        if (round == 0 || roundTargets == null) {
          final pool = List.generate(maxN - minN + 1, (i) => minN + i)..shuffle();
          roundTargets = pool.take(totalRounds).toList();
        }
        final random = Random();
        final target = roundTargets![round];
        final emoji = _objects[random.nextInt(_objects.length)];

        final distractors = <int>{target};
        while (distractors.length < 3) {
          final delta = random.nextInt(4) + 1;
          final candidate = random.nextBool() ? target + delta : target - delta;
          if (candidate >= 1 && candidate <= maxN + 3) distractors.add(candidate);
        }
        final choices = distractors.toList()..shuffle(random);

        return RoundData(
          prompt: Column(
            children: [
              const Text(
                'Quantos você vê?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: List.generate(
                  target,
                  (i) => Text(emoji, style: const TextStyle(fontSize: 34)),
                ),
              ),
            ],
          ),
          promptText: 'Quantos você vê?',
          options: choices
              .map(
                (n) => ChoiceOption(
                  isCorrect: n == target,
                  child: Text(
                    '$n',
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
