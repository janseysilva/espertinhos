import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'squishy_button.dart';

/// Trava dos responsáveis: conta de matemática de 2 dígitos com 6 opções
/// de múltipla escolha (em vez de campo de texto — mais confiável em
/// touch, e é o padrão já validado na versão HTML).
Future<bool> showAdminLockDialog(BuildContext context) async {
  final random = Random();
  final a = random.nextInt(60) + 20;
  final b = random.nextInt(30) + 10;
  final answer = a + b;

  final wrongOptions = <int>{};
  while (wrongOptions.length < 5) {
    final delta = random.nextInt(20) - 10;
    final candidate = answer + (delta == 0 ? 7 : delta);
    if (candidate > 0 && candidate != answer) wrongOptions.add(candidate);
  }
  final options = [answer, ...wrongOptions]..shuffle(random);

  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        constraints: const BoxConstraints(maxWidth: 360),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🔒', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 10),
            const Text(
              'Pergunta para\no responsável',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textDark),
            ),
            const SizedBox(height: 16),
            Text(
              'Quanto é $a + $b?',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.accent),
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: options
                  .map(
                    (opt) => SquishyButton(
                      borderRadius: 16,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      onTap: () => Navigator.pop(ctx, opt == answer),
                      child: Text(
                        '$opt',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar'),
            ),
          ],
        ),
      ),
    ),
  );
  return result ?? false;
}
