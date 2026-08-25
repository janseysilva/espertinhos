import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/tts_service.dart';
import 'voice_settings_dialog.dart';

/// Botão 🗣️ fixo no canto superior esquerdo, visível em qualquer tela —
/// mesmo padrão do [MuteButton] (canto direito). A própria criança pode
/// trocar a voz, sem precisar de um adulto desbloquear.
class VoiceButton extends StatelessWidget {
  const VoiceButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, left: 12),
        child: Material(
          color: Colors.white.withValues(alpha: 0.85),
          shape: const CircleBorder(),
          elevation: 3,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => showVoiceSettingsDialog(context, context.read<TtsService>()),
            child: const Padding(
              padding: EdgeInsets.all(9),
              child: Text('🗣️', style: TextStyle(fontSize: 18)),
            ),
          ),
        ),
      ),
    );
  }
}
