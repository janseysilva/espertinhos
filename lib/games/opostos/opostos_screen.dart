import 'dart:math';

import 'package:flutter/material.dart';

import '../../l10n/app_strings.dart';
import '../../models/age_group.dart';
import '../../widgets/choice_game_scaffold.dart';

class OpostosScreen extends StatelessWidget {
  const OpostosScreen({super.key, required this.age});

  final AgeGroup age;

  @override
  Widget build(BuildContext context) {
    final t = stringsOf(context);
    final pairs = age.level == 2
        ? [...AppStrings.opostosPairIds, AppStrings.opostosExtraPairId]
        : AppStrings.opostosPairIds;
    final allIds = pairs.expand((p) => [p.$1, p.$2]).toList();

    return ChoiceGameScreen(
      gameId: 'opostos',
      title: 'Opostos',
      totalRounds: age.starsToAdvance,
      gridCrossAxisCount: 2,
      optionAspectRatio: 1.4,
      roundGenerator: (round) {
        final random = Random();
        final pairIndex = round % pairs.length;
        final pair = pairs[pairIndex];
        final showFirst = random.nextBool();
        final shownId = showFirst ? pair.$1 : pair.$2;
        final correctId = showFirst ? pair.$2 : pair.$1;

        final wrongPool = allIds.where((id) => id != shownId && id != correctId).toList()..shuffle(random);
        final optionIds = <String>[correctId, ...wrongPool.take(3)]..shuffle(random);

        return RoundData(
          prompt: Column(
            children: [
              Text(
                t.opostosPrompt,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Text(AppStrings.opostosEmoji[shownId]!, style: const TextStyle(fontSize: 56)),
              Text(t.opostosWord(shownId), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
            ],
          ),
          promptText: t.opostosPromptFor(shownId),
          options: optionIds
              .map(
                (id) => ChoiceOption(
                  isCorrect: id == correctId,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppStrings.opostosEmoji[id]!, style: const TextStyle(fontSize: 34)),
                      Text(t.opostosWord(id), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
