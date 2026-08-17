import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/age_group.dart';
import '../../widgets/choice_game_scaffold.dart';

const _letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

class AlfabetoScreen extends StatelessWidget {
  const AlfabetoScreen({super.key, required this.age});

  final AgeGroup age;

  @override
  Widget build(BuildContext context) {
    final optionCount = switch (age.level) { 0 => 3, 1 => 4, _ => 4 };
    final trapMode = age.level == 2;

    return ChoiceGameScreen(
      gameId: 'alfabeto',
      title: 'Alfabeto',
      totalRounds: age.starsToAdvance,
      gridCrossAxisCount: 2,
      optionAspectRatio: 1.6,
      speakPrompts: age.level == 0,
      roundGenerator: (round) {
        final random = Random();
        final targetLetter = _letters[random.nextInt(_letters.length)];
        final wantUpper = trapMode ? random.nextBool() : true;

        final String promptText;
        final String correctDisplay;
        if (trapMode) {
          promptText =
              'Toque na letra "$targetLetter" ${wantUpper ? "MAIÚSCULA" : "minúscula"}';
          correctDisplay = wantUpper ? targetLetter : targetLetter.toLowerCase();
        } else {
          promptText = 'Toque na letra "$targetLetter"';
          correctDisplay = targetLetter;
        }

        final optionsSet = <String>{correctDisplay};
        if (trapMode) {
          optionsSet.add(
            wantUpper ? targetLetter.toLowerCase() : targetLetter.toUpperCase(),
          );
        }
        while (optionsSet.length < optionCount) {
          final other = _letters[random.nextInt(_letters.length)];
          if (other == targetLetter) continue;
          final display = trapMode ? (random.nextBool() ? other : other.toLowerCase()) : other;
          optionsSet.add(display);
        }
        final opts = optionsSet.toList()..shuffle(random);

        return RoundData(
          prompt: Text(
            promptText,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          promptText: promptText,
          options: opts
              .map(
                (l) => ChoiceOption(
                  isCorrect: l == correctDisplay,
                  child: Text(l, style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w800)),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
