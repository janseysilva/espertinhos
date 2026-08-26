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
        return DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.star_rounded, color: AppColors.starOn, size: 15),
                const SizedBox(width: 4),
                Text(
                  '$total de 500',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                    fontSize: 12,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
