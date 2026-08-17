import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/ads_service.dart';
import '../services/app_state.dart';
import '../services/purchase_service.dart';
import '../theme/app_theme.dart';
import 'mascot.dart';
import 'squishy_button.dart';

Future<void> showEndGameDialog(
  BuildContext context, {
  required String gameId,
  required int stars,
  required int maxStars,
  required VoidCallback onReplay,
}) async {
  // Espera o progresso salvar ANTES de abrir a caixa de resultado — sem
  // isso, a criança podia fechar o app rápido demais e a fase desbloqueada
  // não chegava a ser salva de verdade.
  await context.read<AppState>().recordGameResult(gameId, stars, maxStars);
  if (!context.mounted) return;
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: const Color(0xE61E143C),
    builder: (_) => EndGameResultDialog(stars: stars, maxStars: maxStars, onReplay: onReplay),
  );
}

class EndGameResultDialog extends StatefulWidget {
  const EndGameResultDialog({
    super.key,
    required this.stars,
    required this.maxStars,
    required this.onReplay,
  });

  final int stars;
  final int maxStars;
  final VoidCallback onReplay;

  @override
  State<EndGameResultDialog> createState() => _EndGameResultDialogState();
}

class _EndGameResultDialogState extends State<EndGameResultDialog> {
  late final ConfettiController _confetti =
      ConfettiController(duration: const Duration(seconds: 2));

  double get _ratio => widget.maxStars <= 0 ? 0 : widget.stars / widget.maxStars;

  @override
  void initState() {
    super.initState();
    if (_ratio >= 0.75) _confetti.play();
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  String get _message {
    if (_ratio >= 1.0) return 'Perfeito!';
    if (_ratio >= 0.75) return 'Muito bem!';
    if (_ratio >= 0.5) return 'Bom trabalho!';
    return 'Continue tentando!';
  }

  @override
  Widget build(BuildContext context) {
    final starSize = widget.maxStars > 6 ? 22.0 : 30.0;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.fromLTRB(26, 30, 26, 24),
            constraints: const BoxConstraints(maxWidth: 320),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 30, offset: const Offset(0, 10)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Mascot(size: 54),
                const SizedBox(height: 10),
                Text(
                  _message,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textDark),
                ),
                const SizedBox(height: 10),
                Text(
                  '${widget.stars} de ${widget.maxStars} estrelas',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.accent),
                ),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: List.generate(
                    widget.maxStars,
                    (i) => Icon(
                      Icons.star_rounded,
                      color: i < widget.stars ? AppColors.starOn : AppColors.starOff,
                      size: starSize,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: SquishyButton(
                    color: AppColors.bigRed,
                    shadowColor: AppColors.bigRedShadow,
                    borderRadius: 999,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.onReplay();
                    },
                    child: const Center(
                      child: Text(
                        'JOGAR DE NOVO',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.accent,
                      side: const BorderSide(color: AppColors.accent, width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      final nav = Navigator.of(context);
                      final ads = context.read<AdsService>();
                      final adsRemoved = context.read<PurchaseService>().adsRemoved;
                      nav.pop();
                      nav.pop();
                      if (!adsRemoved) ads.showIfReady();
                    },
                    child: const Text('MENU', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
        ConfettiWidget(
          confettiController: _confetti,
          blastDirection: -pi / 2,
          numberOfParticles: 24,
          maxBlastForce: 20,
          minBlastForce: 8,
          gravity: 0.3,
          shouldLoop: false,
        ),
      ],
    );
  }
}
