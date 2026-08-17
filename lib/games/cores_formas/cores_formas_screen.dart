import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/age_group.dart';
import '../../widgets/choice_game_scaffold.dart';

enum _Shape { circulo, quadrado, triangulo, estrela, coracao, losango }

const _shapeNames = {
  _Shape.circulo: 'círculo',
  _Shape.quadrado: 'quadrado',
  _Shape.triangulo: 'triângulo',
  _Shape.estrela: 'estrela',
  _Shape.coracao: 'coração',
  _Shape.losango: 'losango',
};

// "estrela" é a única forma feminina da lista ("na estrela"); as demais
// são masculinas ("no círculo", "no quadrado" etc).
const _feminineShapes = {_Shape.estrela};

const _colors = <String, Color>{
  'vermelho': Color(0xFFEF5350),
  'azul': Color(0xFF2196F3),
  'amarelo': Color(0xFFFFC107),
  'verde': Color(0xFF66BB6A),
  'roxo': Color(0xFF7C4DFF),
  'laranja': Color(0xFFFF7043),
};

// Forma feminina de cada cor, pra concordar com formas femininas (ex:
// "estrela vermelha"). Cores sem entrada aqui (azul/verde/laranja) são
// invariáveis, o nome já serve pros dois gêneros.
const _feminineColorNames = {
  'vermelho': 'vermelha',
  'amarelo': 'amarela',
  'roxo': 'roxa',
};

class CoresFormasScreen extends StatelessWidget {
  const CoresFormasScreen({super.key, required this.age});

  final AgeGroup age;

  @override
  Widget build(BuildContext context) {
    final shapeCount = switch (age.level) { 0 => 3, 1 => 4, _ => 6 };
    final colorCount = switch (age.level) { 0 => 3, 1 => 4, _ => 6 };
    final optionCount = switch (age.level) { 0 => 4, 1 => 6, _ => 8 };
    final shapes = _Shape.values.take(shapeCount).toList();
    final colorNames = _colors.keys.take(colorCount).toList();

    return ChoiceGameScreen(
      gameId: 'cores_formas',
      title: 'Cores e Formas',
      totalRounds: age.starsToAdvance,
      gridCrossAxisCount: optionCount <= 4 ? 2 : 3,
      optionAspectRatio: 1.1,
      speakPrompts: age.level == 0,
      roundGenerator: (round) {
        final random = Random();
        final targetShape = shapes[random.nextInt(shapes.length)];
        final targetColor = colorNames[random.nextInt(colorNames.length)];

        final combos = <(_Shape, String)>{(targetShape, targetColor)};
        while (combos.length < optionCount) {
          final s = shapes[random.nextInt(shapes.length)];
          final c = colorNames[random.nextInt(colorNames.length)];
          combos.add((s, c));
        }
        final options = combos.toList()..shuffle(random);

        final isFeminine = _feminineShapes.contains(targetShape);
        final article = isFeminine ? 'na' : 'no';
        final colorLabel = isFeminine ? (_feminineColorNames[targetColor] ?? targetColor) : targetColor;
        final text = 'Toque $article ${_shapeNames[targetShape]} $colorLabel';
        return RoundData(
          prompt: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          promptText: text,
          options: options
              .map(
                (combo) => ChoiceOption(
                  isCorrect: combo.$1 == targetShape && combo.$2 == targetColor,
                  child: _ShapeIcon(shape: combo.$1, color: _colors[combo.$2]!),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _ShapeIcon extends StatelessWidget {
  const _ShapeIcon({required this.shape, required this.color});

  final _Shape shape;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: CustomPaint(
        painter: _ShapePainter(shape: shape, color: color),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _ShapePainter extends CustomPainter {
  _ShapePainter({required this.shape, required this.color});

  final _Shape shape;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    switch (shape) {
      case _Shape.circulo:
        canvas.drawCircle(center, min(w, h) / 2, paint);
      case _Shape.quadrado:
        final side = min(w, h);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: center, width: side, height: side),
            const Radius.circular(8),
          ),
          paint,
        );
      case _Shape.triangulo:
        final path = Path()
          ..moveTo(w / 2, 0)
          ..lineTo(w, h)
          ..lineTo(0, h)
          ..close();
        canvas.drawPath(path, paint);
      case _Shape.estrela:
        canvas.drawPath(_starPath(center, min(w, h) / 2, min(w, h) / 4.2), paint);
      case _Shape.coracao:
        canvas.drawPath(_heartPath(w, h), paint);
      case _Shape.losango:
        final path = Path()
          ..moveTo(w / 2, 0)
          ..lineTo(w, h / 2)
          ..lineTo(w / 2, h)
          ..lineTo(0, h / 2)
          ..close();
        canvas.drawPath(path, paint);
    }
  }

  Path _starPath(Offset center, double outerR, double innerR) {
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final angle = (pi / 5) * i - pi / 2;
      final r = i.isEven ? outerR : innerR;
      final point = Offset(center.dx + r * cos(angle), center.dy + r * sin(angle));
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    return path;
  }

  Path _heartPath(double w, double h) {
    final path = Path();
    path.moveTo(w / 2, h * 0.9);
    path.cubicTo(-w * 0.1, h * 0.5, w * 0.15, -h * 0.05, w / 2, h * 0.32);
    path.cubicTo(w * 0.85, -h * 0.05, w * 1.1, h * 0.5, w / 2, h * 0.9);
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant _ShapePainter oldDelegate) =>
      oldDelegate.shape != shape || oldDelegate.color != color;
}
