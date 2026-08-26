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
          decoration: const BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.all(Radius.circular(999)),
          ),
          // Emoji e número em Text separados (não numa string só) — juntos
          // numa única peça de texto em negrito, alguns celulares (ex:
          // Xiaomi/MIUI) desenhavam um traço embaixo por confusão de fonte
          // na hora de misturar o emoji com o texto. Cor de fundo também
          // virou opaca (sem transparência) — uma cor semitransparente
          // colorida (diferente do resto dos botões do app, que usam
          // branco) é mais propensa a esse tipo de artefato de desenho.
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🌟', style: TextStyle(fontSize: 12)),
              const SizedBox(width: 4),
              Text(
                '$total / 500',
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark, fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}
