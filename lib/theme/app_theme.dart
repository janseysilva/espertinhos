import 'package:flutter/material.dart';

class AppColors {
  static const purple = Color(0xFF7C4DFF);
  static const teal = Color(0xFF00BFA5);
  static const yellow = Color(0xFFFFC107);
  static const pink = Color(0xFFFF4081);
  static const orange = Color(0xFFFF7043);
  static const blue = Color(0xFF2196F3);
  static const green = Color(0xFF66BB6A);
  static const red = Color(0xFFEF5350);
  static const background = Color(0xFFFFF8ED);

  static const List<Color> palette = [
    purple, teal, yellow, pink, orange, blue, green, red,
  ];

  // Paleta "Espertinhos" (portada da versão HTML/PWA).
  static const accent = Color(0xFF6A4CFF);
  static const textDark = Color(0xFF3D3159);
  static const gold = Color(0xFFFFD166);
  static const starOn = Color(0xFFFFB703);
  static const starOff = Color(0xFFE2DDF5);
  static const success = Color(0xFF06D6A0);
  static const error = Color(0xFFEF476F);
  static const bigRed = Color(0xFFFF6B6B);
  static const bigRedShadow = Color(0xFFC94848);

  static const skyBlue = Color(0xFF8ECFFF);
  static const skyPurple = Color(0xFFA78BFA);
  static const skyGold = gold;

  static const backgroundGradient = LinearGradient(
    begin: Alignment(-0.35, -1),
    end: Alignment(0.35, 1),
    stops: [0.0, 0.45, 1.0],
    colors: [skyBlue, skyPurple, skyGold],
  );
}

/// Sombra "de botão 3D" usada nos cartões e botões brancos do app —
/// imita o `box-shadow: 0 6px 0 rgba(0,0,0,.15)` da versão HTML.
List<BoxShadow> squishyShadow({double offset = 6, Color? color}) {
  final base = color ?? Colors.black.withValues(alpha: 0.15);
  return [
    BoxShadow(color: base, offset: Offset(0, offset)),
  ];
}

ThemeData buildAppTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.accent,
    brightness: Brightness.light,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.skyPurple,
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      headlineMedium: TextStyle(fontWeight: FontWeight.w800, color: AppColors.textDark),
      titleLarge: TextStyle(fontWeight: FontWeight.w800, color: AppColors.textDark),
      titleMedium: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textDark),
      bodyLarge: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black87,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: Colors.black87,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
  );
}
