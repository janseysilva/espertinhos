import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/age_group.dart';
import '../../models/game_order.dart';
import '../../widgets/choice_game_scaffold.dart';

enum _Planet { sol, lua, terra, saturno, marte, jupiter, mercurio, venus, urano, netuno }

const _planetNames = {
  _Planet.sol: 'Sol',
  _Planet.lua: 'Lua',
  _Planet.terra: 'Terra',
  _Planet.saturno: 'Saturno',
  _Planet.marte: 'Marte',
  _Planet.jupiter: 'Júpiter',
  _Planet.mercurio: 'Mercúrio',
  _Planet.venus: 'Vênus',
  _Planet.urano: 'Urano',
  _Planet.netuno: 'Netuno',
};

const _planetColors = {
  _Planet.sol: Color(0xFFFFB300),
  _Planet.lua: Color(0xFFB0BEC5),
  _Planet.terra: Color(0xFF2E7DE0),
  _Planet.saturno: Color(0xFFFFD9A0),
  _Planet.marte: Color(0xFFE05B3C),
  _Planet.jupiter: Color(0xFFE6A567),
  _Planet.mercurio: Color(0xFF9E9E9E),
  _Planet.venus: Color(0xFFF2C078),
  _Planet.urano: Color(0xFF80DEEA),
  _Planet.netuno: Color(0xFF3F62D6),
};

/// Jogo especial — só é jogável depois que a criança acumular estrelas
/// vitalícias suficientes (ver [AppState.isUnlocked]), não faz parte da
/// sequência normal de fases.
class EspacoPlanetasScreen extends StatelessWidget {
  const EspacoPlanetasScreen({super.key, required this.age});

  final AgeGroup age;

  @override
  Widget build(BuildContext context) {
    final planetCount = switch (age.level) { 0 => 4, 1 => 7, _ => 10 };
    final optionCount = switch (age.level) { 0 => 4, 1 => 6, _ => 8 };
    final planets = _Planet.values.take(planetCount).toList();

    return ChoiceGameScreen(
      gameId: kSpecialGameId,
      title: 'Espaço e Planetas',
      totalRounds: age.starsToAdvance,
      gridCrossAxisCount: optionCount <= 4 ? 2 : 3,
      optionAspectRatio: 1.1,
      roundGenerator: (round) {
        final random = Random();
        final target = planets[random.nextInt(planets.length)];

        final chosen = <_Planet>{target};
        while (chosen.length < optionCount && chosen.length < planets.length) {
          chosen.add(planets[random.nextInt(planets.length)]);
        }
        final options = chosen.toList()..shuffle(random);

        final text = switch (target) {
          _Planet.sol => 'Toque no Sol',
          _Planet.lua => 'Toque na Lua',
          _ => 'Toque no planeta ${_planetNames[target]}',
        };
        return RoundData(
          prompt: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          promptText: text,
          options: options
              .map((p) => ChoiceOption(isCorrect: p == target, child: _PlanetIcon(planet: p)))
              .toList(),
        );
      },
    );
  }
}

class _PlanetIcon extends StatelessWidget {
  const _PlanetIcon({required this.planet});

  final _Planet planet;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: CustomPaint(
        painter: _PlanetPainter(planet: planet),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _PlanetPainter extends CustomPainter {
  _PlanetPainter({required this.planet});

  final _Planet planet;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);
    final radius = min(w, h) / 2.6;
    final paint = Paint()..color = _planetColors[planet]!;

    if (planet == _Planet.saturno) {
      final ringPaint = Paint()
        ..color = const Color(0xFFB08D57)
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.28;
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(-0.35);
      canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: radius * 2.6, height: radius * 1.0),
        ringPaint,
      );
      canvas.restore();
    }

    canvas.drawCircle(center, radius, paint);

    if (planet == _Planet.terra) {
      final landPaint = Paint()..color = const Color(0xFF4CAF50);
      canvas.drawCircle(Offset(center.dx - radius * 0.35, center.dy - radius * 0.3), radius * 0.4, landPaint);
      canvas.drawCircle(Offset(center.dx + radius * 0.4, center.dy + radius * 0.35), radius * 0.3, landPaint);
    } else if (planet == _Planet.jupiter) {
      final bandPaint = Paint()
        ..color = const Color(0xFFC97B3D)
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.22;
      canvas.save();
      canvas.clipPath(Path()..addOval(Rect.fromCircle(center: center, radius: radius)));
      canvas.drawLine(
        Offset(center.dx - radius, center.dy - radius * 0.3),
        Offset(center.dx + radius, center.dy - radius * 0.3),
        bandPaint,
      );
      canvas.drawLine(
        Offset(center.dx - radius, center.dy + radius * 0.35),
        Offset(center.dx + radius, center.dy + radius * 0.35),
        bandPaint,
      );
      canvas.restore();
    } else if (planet == _Planet.sol) {
      final rayPaint = Paint()
        ..color = _planetColors[planet]!.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.18;
      for (var i = 0; i < 8; i++) {
        final angle = (pi / 4) * i;
        final inner = Offset(center.dx + radius * 1.12 * cos(angle), center.dy + radius * 1.12 * sin(angle));
        final outer = Offset(center.dx + radius * 1.4 * cos(angle), center.dy + radius * 1.4 * sin(angle));
        canvas.drawLine(inner, outer, rayPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PlanetPainter oldDelegate) => oldDelegate.planet != planet;
}
