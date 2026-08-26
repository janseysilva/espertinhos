import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/app_state.dart';
import '../theme/app_theme.dart';

/// Contador de estrelas vitalício, fixo no canto superior direito —
/// visível em qualquer tela.
class StarCounterBadge extends StatelessWidget {
  const StarCounterBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return StreamBuilder<int>(
      stream: appState.lifetimeStarsStream,
      builder: (context, snap) {
        final total = snap.data ?? 0;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '🌟 $total / 500',
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark, fontSize: 12),
          ),
        );
      },
    );
  }
}
