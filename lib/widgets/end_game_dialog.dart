import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/ads_service.dart';
import '../services/app_state.dart';
import '../services/music_service.dart';
import '../services/purchase_service.dart';
import '../theme/app_theme.dart';
import 'mascot.dart';
import 'squishy_button.dart';

/// Tempo máximo de espera pelo anúncio antes de liberar a criança mesmo
/// assim — sem essa rede de segurança, sem internet ela ficaria travada
/// pra sempre nessa tela (o anúncio nunca chega a carregar).
const _adWaitSeconds = 30;

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

  // A criança só sai dessa tela depois de assistir ao anúncio (ou de um
  // tempo máximo de espera, se não tiver anúncio disponível — ex: sem
  // internet). Enquanto isso, os botões ficam escondidos.
  bool _canContinue = false;
  int _secondsLeft = _adWaitSeconds;
  Timer? _countdownTimer;

  double get _ratio => widget.maxStars <= 0 ? 0 : widget.stars / widget.maxStars;

  @override
  void initState() {
    super.initState();
    if (_ratio >= 0.75) _confetti.play();
    _watchAd();
  }

  Future<void> _watchAd() async {
    if (context.read<PurchaseService>().adsRemoved) {
      setState(() => _canContinue = true);
      return;
    }
    final ads = context.read<AdsService>();
    final music = context.read<MusicService>();
    await music.pauseForAd();
    ads.showIfReady(
      onClosed: () {
        music.resumeIfNeeded();
        _countdownTimer?.cancel();
        if (mounted) setState(() => _canContinue = true);
      },
    );
    // Se não tinha anúncio pronto (sem internet, por exemplo), showIfReady
    // não chama onClosed — a contagem regressiva libera a criança mesmo
    // assim ao chegar em zero, em vez de travar o app pra sempre.
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() {
          _secondsLeft = 0;
          _canContinue = true;
        });
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _confetti.dispose();
    super.dispose();
  }

  // Personaliza a mensagem com o nome da criança (capturado na primeira
  // vez que o app abre) — "Parabéns, Maria!" em vez de só "Parabéns!".
  String _messageFor(String? name) {
    final who = (name == null || name.isEmpty) ? '' : ', $name';
    if (_ratio >= 1.0) return 'Parabéns$who! Perfeito!';
    if (_ratio >= 0.75) return 'Parabéns$who! Muito bem!';
    if (_ratio >= 0.5) return 'Bom trabalho$who!';
    return 'Continue tentando$who!';
  }

  @override
  Widget build(BuildContext context) {
    final starSize = widget.maxStars > 6 ? 22.0 : 30.0;
    final childName = context.watch<AppState>().childName;
    return PopScope(
      // Trava o botão "voltar" do Android enquanto espera o anúncio, senão
      // a criança escapa dessa tela sem assistir.
      canPop: _canContinue,
      child: Stack(
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
                    _messageFor(childName),
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
                  if (!_canContinue)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: [
                          const SizedBox(
                            width: 26,
                            height: 26,
                            child: CircularProgressIndicator(strokeWidth: 3, color: AppColors.accent),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Aguardando anúncio...',
                            style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$_secondsLeft',
                            style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w800, fontSize: 20),
                          ),
                        ],
                      ),
                    )
                  else ...[
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
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: const Text('MENU', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                  ],
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
      ),
    );
  }
}
