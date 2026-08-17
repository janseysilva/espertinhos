import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/age_group.dart';
import '../../widgets/choice_game_scaffold.dart';

class _Word {
  const _Word(this.text, this.emoji);
  final String text;
  final String emoji;
}

const _basePairs = <(_Word, _Word)>[
  (_Word('Dia', '☀️'), _Word('Noite', '🌙')),
  (_Word('Grande', '🐘'), _Word('Pequeno', '🐭')),
  (_Word('Quente', '🔥'), _Word('Frio', '❄️')),
  (_Word('Feliz', '😄'), _Word('Triste', '😢')),
  (_Word('Rápido', '🐇'), _Word('Lento', '🐢')),
  (_Word('Em cima', '⬆️'), _Word('Embaixo', '⬇️')),
  (_Word('Aberto', '🔓'), _Word('Fechado', '🔒')),
];

const _extraPair = (_Word('Molhado', '💧'), _Word('Seco', '🏜️'));

class OpostosScreen extends StatelessWidget {
  const OpostosScreen({super.key, required this.age});

  final AgeGroup age;

  @override
  Widget build(BuildContext context) {
    final pairs = age.level == 2 ? [..._basePairs, _extraPair] : _basePairs;
    final allWords = pairs.expand((p) => [p.$1, p.$2]).toList();

    return ChoiceGameScreen(
      gameId: 'opostos',
      title: 'Opostos',
      totalRounds: 8,
      gridCrossAxisCount: 2,
      optionAspectRatio: 1.4,
      speakPrompts: age.level == 0,
      roundGenerator: (round) {
        final random = Random();
        final pairIndex = round % pairs.length;
        final pair = pairs[pairIndex];
        final showFirst = random.nextBool();
        final shown = showFirst ? pair.$1 : pair.$2;
        final correct = showFirst ? pair.$2 : pair.$1;

        final wrongPool = allWords.where((w) => w != shown && w != correct).toList()..shuffle(random);
        final options = <_Word>[correct, ...wrongPool.take(3)]..shuffle(random);

        return RoundData(
          prompt: Column(
            children: [
              const Text(
                'Qual é o contrário?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Text(shown.emoji, style: const TextStyle(fontSize: 56)),
              Text(shown.text, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
            ],
          ),
          promptText: 'Qual é o contrário de ${shown.text}?',
          options: options
              .map(
                (w) => ChoiceOption(
                  isCorrect: w == correct,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(w.emoji, style: const TextStyle(fontSize: 34)),
                      Text(w.text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
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
