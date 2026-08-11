import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class FeedbackFlash extends StatelessWidget {
  const FeedbackFlash({super.key, required this.correct});

  final bool? correct;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedOpacity(
        opacity: correct == null ? 0 : 1,
        duration: const Duration(milliseconds: 150),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 16),
              ],
            ),
            child: Icon(
              correct == true ? Icons.check_circle_rounded : Icons.cancel_rounded,
              color: correct == true ? AppColors.success : AppColors.error,
              size: 72,
            ),
          ),
        ),
      ),
    );
  }
}
