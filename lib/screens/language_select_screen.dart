import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_strings.dart';
import '../models/app_language.dart';
import '../services/app_state.dart';
import '../services/tts_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_background.dart';
import '../widgets/mascot.dart';
import '../widgets/squishy_button.dart';
import 'age_select_screen.dart';
import 'name_capture_screen.dart';

/// Primeira tela que a criança/responsável vê, só na primeira vez que abre
/// o app — escolhe o idioma que o app inteiro (jogos + narração por voz) vai
/// usar dali pra frente. Como ainda não sabemos que idioma a pessoa fala, o
/// título e os nomes de cada opção aparecem no próprio idioma deles
/// (autônimo), não traduzidos.
class LanguageSelectScreen extends StatelessWidget {
  const LanguageSelectScreen({super.key});

  Future<void> _choose(BuildContext context, AppLanguage language) async {
    final appState = context.read<AppState>();
    final tts = context.read<TtsService>();
    await appState.setLanguage(language);
    if (!context.mounted) return;
    await tts.setAppLocale(language.ttsLocale);
    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => appState.childName == null ? const NameCaptureScreen() : const AgeSelectScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = stringsOf(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.fromLTRB(26, 30, 26, 26),
                constraints: const BoxConstraints(maxWidth: 380),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 24, offset: const Offset(0, 10)),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Mascot(size: 64),
                    const SizedBox(height: 12),
                    Text(
                      t.chooseLanguageTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textDark),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 12,
                      children: AppLanguage.values
                          .map((lang) => _LanguageCard(language: lang, onTap: () => _choose(context, lang)))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({required this.language, required this.onTap});

  final AppLanguage language;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SquishyButton(
      onTap: onTap,
      borderRadius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      color: const Color(0xFFEFE9FF),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(language.flag, style: const TextStyle(fontSize: 38)),
          const SizedBox(height: 8),
          Text(
            language.nativeName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark),
          ),
        ],
      ),
    );
  }
}
