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

/// Escolha do idioma que o app inteiro (jogos + narração por voz) vai usar.
/// Aparece na primeira vez que o app abre (antes do nome/idade) e também
/// pode ser reaberta depois — pelo botão "🌐 Idioma" na tela inicial, atrás
/// da trava dos responsáveis — caso alguém tenha clicado errado da primeira
/// vez. Como nem sempre sabemos que idioma a pessoa fala (na primeira vez,
/// por exemplo), o título e os nomes de cada opção aparecem no próprio
/// idioma deles (autônimo), não traduzidos.
class LanguageSelectScreen extends StatelessWidget {
  const LanguageSelectScreen({super.key, this.fromSettings = false});

  /// true quando reaberta pela tela inicial (já tem idioma/nome/idade
  /// salvos) — nesse caso só troca o idioma e volta, sem repetir o
  /// onboarding (nome/idade) do zero.
  final bool fromSettings;

  Future<void> _choose(BuildContext context, AppLanguage language) async {
    final appState = context.read<AppState>();
    final tts = context.read<TtsService>();
    await appState.setLanguage(language);
    if (!context.mounted) return;
    await tts.setAppLocale(language.ttsLocale);
    if (!context.mounted) return;
    if (fromSettings) {
      Navigator.of(context).pop();
      return;
    }
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
                    // Grade 2x2 com `Expanded` (não `Wrap` com largura fixa) —
                    // assim os cartões sempre cabem 2 por linha e dividem a
                    // largura disponível igualmente, em qualquer tamanho de
                    // tela. Com largura fixa em pixels, telas mais estreitas
                    // só cabiam 1 cartão por linha e todos empilhavam.
                    for (var i = 0; i < AppLanguage.values.length; i += 2)
                      Padding(
                        padding: EdgeInsets.only(top: i == 0 ? 0 : 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: _LanguageCard(
                                language: AppLanguage.values[i],
                                onTap: () => _choose(context, AppLanguage.values[i]),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _LanguageCard(
                                language: AppLanguage.values[i + 1],
                                onTap: () => _choose(context, AppLanguage.values[i + 1]),
                              ),
                            ),
                          ],
                        ),
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
    // Altura fixa pros 4 cartões ficarem do mesmo tamanho (a largura já vem
    // igual, de um `Expanded` no pai) — sem isso, nomes de idioma com
    // tamanhos bem diferentes (ex: "English" x "Português (Brasil)")
    // faziam os cartões crescerem cada um pro seu lado.
    return SizedBox(
      height: 118,
      child: SquishyButton(
        onTap: onTap,
        borderRadius: 20,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        color: const Color(0xFFEFE9FF),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(language.flag, style: const TextStyle(fontSize: 30)),
            const SizedBox(height: 6),
            Text(
              language.nativeName,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark, height: 1.15),
            ),
          ],
        ),
      ),
    );
  }
}
