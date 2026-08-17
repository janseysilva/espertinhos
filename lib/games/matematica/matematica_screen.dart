import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/age_group.dart';
import '../../widgets/choice_game_scaffold.dart';

const _objects = ['🍎', '🍓', '⭐', '🐠', '🎈'];

class MatematicaScreen extends StatelessWidget {
  const MatematicaScreen({super.key, required this.age});

  final AgeGroup age;

  @override
  Widget build(BuildContext context) {
    final maxSum = switch (age.level) { 0 => 5, 1 => 9, _ => 20 };
    final allowSubtraction = age.level >= 1;
    final useIcons = age.level <= 1;

    return ChoiceGameScreen(
      gameId: 'matematica',
      title: 'Matemática',
      totalRounds: age.starsToAdvance,
      gridCrossAxisCount: 3,
      optionAspectRatio: 1.0,
      speakPrompts: age.level == 0,
      roundGenerator: (round) {
        final random = Random();
        final isSubtraction = allowSubtraction && random.nextBool();
        int a, b, result;
        if (isSubtraction) {
          a = 2 + random.nextInt(maxSum - 1);
          b = 1 + random.nextInt(a - 1);
          result = a - b;
        } else {
          result = 2 + random.nextInt(maxSum - 1);
          a = 1 + random.nextInt(result - 1);
          b = result - a;
        }
        final emoji = _objects[random.nextInt(_objects.length)];
        final opSymbol = isSubtraction ? '−' : '+';

        final distractors = <int>{result};
        while (distractors.length < 3) {
          final delta = random.nextInt(4) + 1;
          final candidate = random.nextBool() ? result + delta : result - delta;
          if (candidate >= 0 && candidate <= maxSum + 3) distractors.add(candidate);
        }
        final choices = distractors.toList()..shuffle(random);

        final Widget prompt = useIcons
            ? Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 6,
                runSpacing: 6,
                children: [
                  ...List.generate(a, (_) => Text(emoji, style: const TextStyle(fontSize: 28))),
                  Text(opSymbol, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
                  ...List.generate(b, (_) => Text(emoji, style: const TextStyle(fontSize: 28))),
                  const Text('=', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
                  const Text('?', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
                ],
              )
            : Text(
                '$a $opSymbol $b = ?',
                style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800),
              );

        return RoundData(
          prompt: prompt,
          promptText: 'Quanto é $a ${isSubtraction ? "menos" : "mais"} $b?',
          options: choices
              .map(
                (n) => ChoiceOption(
                  isCorrect: n == result,
                  child: Text('$n', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
