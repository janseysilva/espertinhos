enum AppLanguage { ptBr, ptPt, en, es }

extension AppLanguageX on AppLanguage {
  String get id => switch (this) {
        AppLanguage.ptBr => 'pt_br',
        AppLanguage.ptPt => 'pt_pt',
        AppLanguage.en => 'en',
        AppLanguage.es => 'es',
      };

  /// Código usado pelo motor de texto-pra-fala (`flutter_tts`).
  String get ttsLocale => switch (this) {
        AppLanguage.ptBr => 'pt-BR',
        AppLanguage.ptPt => 'pt-PT',
        AppLanguage.en => 'en-US',
        AppLanguage.es => 'es-ES',
      };

  String get flag => switch (this) {
        AppLanguage.ptBr => '🇧🇷',
        AppLanguage.ptPt => '🇵🇹',
        AppLanguage.en => '🇺🇸',
        AppLanguage.es => '🇪🇸',
      };

  /// Nome do idioma escrito nele mesmo (autônimo), pra mostrar na tela de
  /// seleção antes de saber qual idioma a pessoa fala.
  String get nativeName => switch (this) {
        AppLanguage.ptBr => 'Português (Brasil)',
        AppLanguage.ptPt => 'Português (Portugal)',
        AppLanguage.en => 'English',
        AppLanguage.es => 'Español',
      };

  static AppLanguage fromId(String id) => AppLanguage.values.firstWhere(
        (e) => e.id == id,
        orElse: () => AppLanguage.ptBr,
      );
}
