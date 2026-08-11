import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'squishy_button.dart';

/// Cabeçalho dos jogos: botão "← Voltar" + selo de progresso opcional
/// (com ou sem barrinha), reproduzindo `.btnBack` + `.gameHeader` do HTML.
/// Não é mais uma AppBar — fica dentro do corpo, sobre o fundo em degradê.
class GameTopBar extends StatelessWidget {
  const GameTopBar({
    super.key,
    this.progressLabel,
    this.progress,
    this.onBack,
  });

  /// Texto do selo de progresso, ex: "1 / 8" ou "Jogadas: 3". Nulo = sem selo.
  final String? progressLabel;

  /// 0..1 para mostrar a barrinha de progresso. Nulo = sem barra.
  final double? progress;

  /// Ação do botão "← Voltar". Padrão: fecha a tela (Navigator.pop).
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SquishyButton(
              color: Colors.white.withValues(alpha: 0.85),
              borderRadius: 999,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              onTap: onBack ?? () => Navigator.of(context).pop(),
              child: const Text(
                '← Voltar',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark, fontSize: 14),
              ),
            ),
          ],
        ),
        if (progressLabel != null) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              progressLabel!,
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark, fontSize: 14),
            ),
          ),
          if (progress != null) ...[
            const SizedBox(height: 8),
            Center(
              child: Container(
                width: 220,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress!.clamp(0.0, 1.0).toDouble(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ],
    );
  }
}
