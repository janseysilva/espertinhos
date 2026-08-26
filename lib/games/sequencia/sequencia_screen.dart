import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/age_group.dart';
import '../../theme/app_theme.dart';
import '../../widgets/choice_game_scaffold.dart';

class SequenciaScreen extends StatelessWidget {
  const SequenciaScreen({super.key, required this.age});

  final AgeGroup age;

  @override
  Widget build(BuildContext context) {
    final palette = switch (age.level) {
      0 => AppColors.palette.take(3).toList(),
      1 => AppColors.palette.take(4).toList(),
      _ => AppColors.palette.take(6).toList(),
    };
    final unitLenRange = switch (age.level) { 0 => (2, 2), 1 => (2, 3), _ => (3, 4) };
    final displayLen = switch (age.level) { 0 => 5, 1 => 7, _ => 9 };
    // Guarda os padrões já perguntados nessa partida (pela cor, não pela
    // "resposta" — o padrão de repetição raramente tem cores suficientes
    // pra nunca repetir a resposta certa), pra nunca repetir o mesmo
    // desenho de sequência em rodadas diferentes.
    final usedPatterns = <String>{};

    return ChoiceGameScreen(
      gameId: 'sequencia',
      title: 'Sequência',
      totalRounds: age.starsToAdvance,
      gridCrossAxisCount: palette.length <= 3 ? 3 : 4,
      optionAspectRatio: 1.0,
      roundGenerator: (round) {
        if (round == 0) usedPatterns.clear();
        final random = Random();
        List<Color> unit;
        var attempts = 0;
        do {
          attempts++;
          final unitLen = unitLenRange.$1 +
              (unitLenRange.$2 > unitLenRange.$1 ? random.nextInt(unitLenRange.$2 - unitLenRange.$1 + 1) : 0);
          unit = List.generate(unitLen, (_) => palette[random.nextInt(palette.length)]);
        } while (attempts < 100 && usedPatterns.contains(unit.map((c) => c.toARGB32()).join(',')));
        usedPatterns.add(unit.map((c) => c.toARGB32()).join(','));
        final unitLen = unit.length;
        final sequence = List.generate(displayLen, (i) => unit[i % unitLen]);
        final next = unit[displayLen % unitLen];

        final wrongOptions = palette.where((c) => c != next).toList()..shuffle(random);
        final optionCount = min(palette.length, 4);
        final options = <Color>[next, ...wrongOptions.take(optionCount - 1)]..shuffle(random);

        return RoundData(
          prompt: Column(
            children: [
              const Text(
                'Qual cor vem a seguir?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...sequence.map((c) => _Dot(color: c)),
                  const _Dot(color: Colors.black12, child: Text('?', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
            ],
          ),
          promptText: 'Qual cor vem a seguir?',
          options: options
              .map((c) => ChoiceOption(isCorrect: c == next, child: _Dot(color: c, size: 48)))
              .toList(),
        );
      },
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color, this.size = 36, this.child});

  final Color color;
  final double size;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: child,
    );
  }
}
