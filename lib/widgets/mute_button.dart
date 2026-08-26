import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/music_service.dart';

/// Botão 🔊/🔇 — fica no canto superior direito, abaixo do contador de
/// estrelas (posicionamento feito por quem usa o widget, em [app.dart]).
/// Visível em qualquer tela, inclusive durante os jogos, pra dar pra mutar
/// a qualquer momento — fica no lado direito pra não brigar com o botão
/// "Voltar" de cada jogo, que fica no canto esquerdo.
class MuteButton extends StatelessWidget {
  const MuteButton({super.key});

  @override
  Widget build(BuildContext context) {
    final music = context.watch<MusicService>();
    return Material(
      color: Colors.white.withValues(alpha: 0.85),
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => context.read<MusicService>().toggleMute(),
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: Text(
            music.muted ? '🔇' : '🔊',
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
