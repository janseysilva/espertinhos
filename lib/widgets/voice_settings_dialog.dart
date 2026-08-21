import 'package:flutter/material.dart';

import '../services/tts_service.dart';
import '../theme/app_theme.dart';
import 'squishy_button.dart';

const _samplePhrase = 'Toque no círculo azul';

/// Deixa o adulto escolher, entre as vozes em português instaladas no
/// próprio aparelho, qual delas o app usa pra falar os comandos — não dá
/// pra saber de antemão quais vozes existem em cada celular, então o app
/// pergunta direto pro sistema e deixa ouvir uma amostra antes de escolher.
Future<void> showVoiceSettingsDialog(BuildContext context, TtsService tts) async {
  await showDialog<void>(
    context: context,
    builder: (_) => _VoiceSettingsDialog(tts: tts),
  );
}

class _VoiceSettingsDialog extends StatefulWidget {
  const _VoiceSettingsDialog({required this.tts});

  final TtsService tts;

  @override
  State<_VoiceSettingsDialog> createState() => _VoiceSettingsDialogState();
}

class _VoiceSettingsDialogState extends State<_VoiceSettingsDialog> {
  List<Map<String, String>>? _voices;
  Map<String, String>? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.tts.selectedVoice;
    _load();
  }

  Future<void> _load() async {
    final voices = await widget.tts.listPortugueseVoices();
    if (mounted) setState(() => _voices = voices);
  }

  Future<void> _choose(Map<String, String>? voice) async {
    setState(() => _selected = voice);
    await widget.tts.setPreferredVoice(voice);
    await widget.tts.speak(_samplePhrase);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 26, 24, 20),
        constraints: const BoxConstraints(maxWidth: 380, maxHeight: 480),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🗣️', style: TextStyle(fontSize: 36)),
            const SizedBox(height: 8),
            const Text(
              'Escolha a voz',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textDark),
            ),
            const SizedBox(height: 4),
            const Text(
              'Toque numa opção pra ouvir um exemplo',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: _voices == null
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: CircularProgressIndicator(),
                    )
                  : _voices!.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Não encontrei outras vozes em português nesse\naparelho — só a voz padrão do sistema está disponível.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black54),
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              _VoiceTile(
                                label: 'Padrão do aparelho',
                                selected: _selected == null,
                                onTap: () => _choose(null),
                              ),
                              for (final (i, v) in _voices!.indexed)
                                _VoiceTile(
                                  label: 'Voz ${i + 1}',
                                  selected: _selected != null && _selected!['name'] == v['name'],
                                  onTap: () => _choose(v),
                                ),
                            ],
                          ),
                        ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: SquishyButton(
                color: AppColors.accent,
                borderRadius: 999,
                padding: const EdgeInsets.symmetric(vertical: 12),
                onTap: () => Navigator.of(context).pop(),
                child: const Center(
                  child: Text(
                    'PRONTO',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VoiceTile extends StatelessWidget {
  const _VoiceTile({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: selected ? AppColors.accent.withValues(alpha: 0.12) : const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(
                  selected ? Icons.play_circle_fill : Icons.play_circle_outline,
                  color: AppColors.accent,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                if (selected) const Icon(Icons.check_circle, color: AppColors.success, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
