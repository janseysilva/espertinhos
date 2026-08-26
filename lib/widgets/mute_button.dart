import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/music_service.dart';

/// Botão 🔊/🔇 fixo no canto superior esquerdo, visível em qualquer tela
/// (inclusive durante os jogos, pra dar pra mutar a qualquer momento).
class MuteButton extends StatelessWidget {
  const MuteButton({super.key});

  @override
  Widget build(BuildContext context) {
    final music = context.watch<MusicService>();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, left: 12),
        child: Material(
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
        ),
      ),
    );
  }
}
