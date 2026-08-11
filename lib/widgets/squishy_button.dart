import 'package:flutter/material.dart';

/// Botão "elástico": afunda e a sombra encolhe ao tocar, igual ao
/// `:active { transform: translateY(4px) }` usado em toda a versão HTML.
class SquishyButton extends StatefulWidget {
  const SquishyButton({
    super.key,
    required this.child,
    required this.onTap,
    this.color = Colors.white,
    this.borderRadius = 20,
    this.shadowColor,
    this.padding,
    this.border,
    this.pressDistance = 4,
    this.restDistance = 6,
    this.extraShadow,
  });

  final Widget child;
  final VoidCallback? onTap;
  final Color color;
  final double borderRadius;
  final Color? shadowColor;
  final EdgeInsetsGeometry? padding;
  final Border? border;
  final double pressDistance;
  final double restDistance;

  /// Sombra adicional (borrada) somada à sombra "de botão", para cartões
  /// que precisam de mais profundidade (ex: cartões de jogo na home).
  final List<BoxShadow>? extraShadow;

  @override
  State<SquishyButton> createState() => _SquishyButtonState();
}

class _SquishyButtonState extends State<SquishyButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (widget.onTap == null) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final shadowColor = widget.shadowColor ?? Colors.black.withValues(alpha: 0.15);
    final restShadow = widget.restDistance;
    final pressShadow = widget.pressDistance / 1.5;
    final shadowDistance = _pressed ? pressShadow : restShadow;
    final travel = restShadow - pressShadow;

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _pressed ? travel : 0, 0),
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: widget.border,
          boxShadow: [
            BoxShadow(color: shadowColor, offset: Offset(0, shadowDistance)),
            ...?widget.extraShadow,
          ],
        ),
        child: widget.child,
      ),
    );
  }
}
