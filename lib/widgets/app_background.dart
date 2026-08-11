import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Fundo em degradê (céu → roxo → dourado) usado em todas as telas,
/// igual ao `#app { background: linear-gradient(...) }` da versão HTML.
class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: child,
    );
  }
}
