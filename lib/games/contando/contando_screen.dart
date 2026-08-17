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

    return ChoiceGameScreen(
      gameId: 'contando',
      title: 'Contando',
      totalRounds: age.starsToAdvance,
      gridCrossAxisCount: 3,
      optionAspectRatio: 1.0,
      speakPrompts: age.level == 0,
      roundGenerator: (round) {
        final random = Random();
        final target = minN + random.nextInt(maxN - minN + 1);
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
