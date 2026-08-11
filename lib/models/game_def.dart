import 'package:flutter/material.dart';

import 'age_group.dart';

class GameDef {
  const GameDef({
    required this.id,
    required this.title,
    required this.emoji,
    required this.color,
    required this.maxStars,
    required this.builder,
  });

  final String id;
  final String title;
  final String emoji;
  final Color color;

  /// Total de estrelas possível nesse jogo (bate com o número de rodadas
  /// nos jogos de múltipla escolha; fixo em 5 nos demais).
  final int maxStars;
  final Widget Function(AgeGroup age) builder;
}
