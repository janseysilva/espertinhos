import 'dart:math';

import 'package:flutter/material.dart';

/// Mascote animado — replica o keyframe `mascotBounce` da versão HTML
/// (sobe e balança levemente, em loop contínuo).
class Mascot extends StatefulWidget {
  const Mascot({super.key, this.size = 64, this.emoji = '🐰'});

  final double size;
  final String emoji;

  @override
  State<Mascot> createState() => _MascotState();
}

class _MascotState extends State<Mascot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value * 2 * pi;
        final dy = -(widget.size * 0.14) * (0.5 - 0.5 * cos(t));
        final angle = (4 * pi / 180) * sin(t + pi / 3);
        return Transform.translate(
          offset: Offset(0, dy),
          child: Transform.rotate(angle: angle, child: child),
        );
      },
      child: Text(widget.emoji, style: TextStyle(fontSize: widget.size)),
    );
  }
}
