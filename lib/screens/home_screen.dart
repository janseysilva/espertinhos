import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../games/ache_diferente/ache_diferente_screen.dart';
import '../games/alfabeto/alfabeto_screen.dart';
import '../games/caca_palavras/caca_palavras_screen.dart';
import '../games/contando/contando_screen.dart';
import '../games/cores_formas/cores_formas_screen.dart';
import '../games/maior_menor/maior_menor_screen.dart';
import '../games/matematica/matematica_screen.dart';
import '../games/memoria/memoria_screen.dart';
import '../games/opostos/opostos_screen.dart';
import '../games/pintar/pintar_screen.dart';
import '../games/quebra_cabeca/quebra_cabeca_screen.dart';
import '../games/sequencia/sequencia_screen.dart';
import '../models/age_group.dart';
import '../models/game_def.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/admin_lock_dialog.dart';
import '../widgets/app_background.dart';
import '../widgets/mascot.dart';
import '../widgets/squishy_button.dart';
import 'age_select_screen.dart';

final List<GameDef> kGames = [
  GameDef(
    id: 'cores_formas',
    title: 'Cores e Formas',
    emoji: '🎨',
    color: AppColors.red,
    maxStars: 8,
    builder: (age) => CoresFormasScreen(age: age),
  ),
  GameDef(
    id: 'contando',
    title: 'Contando',
    emoji: '🔢',
    color: AppColors.green,
    maxStars: 8,
    builder: (age) => ContandoScreen(age: age),
  ),
  GameDef(
    id: 'memoria',
    title: 'Memória',
    emoji: '🧠',
    color: AppColors.orange,
    maxStars: 8,
    builder: (age) => MemoriaScreen(age: age),
  ),
  GameDef(
    id: 'alfabeto',
    title: 'Alfabeto',
    emoji: '🔤',
    color: AppColors.blue,
    maxStars: 8,
    builder: (age) => AlfabetoScreen(age: age),
  ),
  GameDef(
    id: 'matematica',
    title: 'Matemática',
    emoji: '➕',
    color: AppColors.purple,
    maxStars: 8,
    builder: (age) => MatematicaScreen(age: age),
  ),
  GameDef(
    id: 'sequencia',
    title: 'Sequência',
    emoji: '🧩',
    color: AppColors.teal,
    maxStars: 8,
    builder: (age) => SequenciaScreen(age: age),
  ),
  GameDef(
    id: 'pintar',
    title: 'Pintar',
    emoji: '🖌️',
    color: AppColors.pink,
    maxStars: 8,
    builder: (age) => PintarScreen(age: age),
  ),
  GameDef(
    id: 'ache_diferente',
    title: 'Ache o Diferente',
    emoji: '🔍',
    color: AppColors.yellow,
    maxStars: 8,
    builder: (age) => AcheDiferenteScreen(age: age),
  ),
  GameDef(
    id: 'maior_menor',
    title: 'Maior ou Menor',
    emoji: '⚖️',
    color: AppColors.blue,
    maxStars: 8,
    builder: (age) => MaiorMenorScreen(age: age),
  ),
  GameDef(
    id: 'opostos',
    title: 'Opostos',
    emoji: '🔄',
    color: AppColors.orange,
    maxStars: 8,
    builder: (age) => OpostosScreen(age: age),
  ),
  GameDef(
    id: 'quebra_cabeca',
    title: 'Quebra-cabeça',
    emoji: '🖼️',
    color: AppColors.green,
    maxStars: 8,
    builder: (age) => QuebraCabecaScreen(age: age),
  ),
  GameDef(
    id: 'caca_palavras',
    title: 'Caça-Palavras',
    emoji: '🔠',
    color: AppColors.purple,
    maxStars: 8,
    builder: (age) => CacaPalavrasScreen(age: age),
  ),
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _changeAge(BuildContext context) async {
    final ok = await showAdminLockDialog(context);
    if (!ok || !context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AgeSelectScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final age = appState.ageGroup ?? AgeGroup.faixa5a6;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              children: [
                const Mascot(size: 64),
                const SizedBox(height: 6),
                const Text(
                  'Espertinhos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    shadows: [Shadow(color: Colors.black26, offset: Offset(0, 3))],
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    SquishyButton(
                      color: Colors.white.withValues(alpha: 0.85),
                      borderRadius: 999,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      onTap: () => _changeAge(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(age.emoji, style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 6),
                          Text(
                            '${age.label} · trocar',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accent, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder<int>(
                      stream: appState.lifetimeStarsStream,
                      builder: (context, snap) {
                        final total = snap.data ?? 0;
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '🌟 $total / 500',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark, fontSize: 12),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 1.05,
                    ),
                    itemCount: kGames.length,
                    itemBuilder: (context, i) {
                      final game = kGames[i];
                      final unlocked = appState.isUnlocked(game.id);
                      return _GameTile(
                        game: game,
                        index: i,
                        unlocked: unlocked,
                        onTap: () {
                          if (!unlocked) {
                            final prevMax = i > 0 ? kGames[i - 1].maxStars : game.maxStars;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('🔒 Consiga as $prevMax estrelas da fase anterior pra desbloquear essa!'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            return;
                          }
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => game.builder(age)),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GameTile extends StatelessWidget {
  const _GameTile({
    required this.game,
    required this.index,
    required this.unlocked,
    required this.onTap,
  });

  final GameDef game;
  final int index;
  final bool unlocked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SquishyButton(
      borderRadius: 22,
      onTap: onTap,
      restDistance: 6,
      color: unlocked ? Colors.white : const Color(0xFFECEAF4),
      extraShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 14, offset: const Offset(0, 6))],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: (unlocked ? AppColors.accent : Colors.grey).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'FASE ${index + 1}',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: unlocked ? AppColors.accent : Colors.grey.shade600,
                ),
              ),
            ),
            const SizedBox(height: 6),
            unlocked
                ? _WigglingEmoji(emoji: game.emoji, delayMs: (index % 4) * 350)
                : Icon(Icons.lock_rounded, size: 34, color: Colors.grey.shade500),
            const SizedBox(height: 8),
            Text(
              game.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: unlocked ? AppColors.textDark : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Ícone com balancinho contínuo — imita o `iconWiggle` do CSS, com atraso
/// escalonado por cartão (nth-child) pra não ficarem todos sincronizados.
class _WigglingEmoji extends StatefulWidget {
  const _WigglingEmoji({required this.emoji, required this.delayMs});

  final String emoji;
  final int delayMs;

  @override
  State<_WigglingEmoji> createState() => _WigglingEmojiState();
}

class _WigglingEmojiState extends State<_WigglingEmoji> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3200),
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.delayMs), () {
      if (mounted) _controller.repeat();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        double angle = 0;
        double scale = 1;
        if (t < 0.10) {
          final p = t / 0.10;
          angle = -10 * pi / 180 * p;
          scale = 1 + 0.05 * p;
        } else if (t < 0.20) {
          final p = (t - 0.10) / 0.10;
          angle = (-10 + 18 * p) * pi / 180;
          scale = 1.05;
        } else if (t < 0.30) {
          final p = (t - 0.20) / 0.10;
          angle = (8 - 8 * p) * pi / 180;
          scale = 1.05 - 0.05 * p;
        }
        return Transform.rotate(
          angle: angle,
          child: Transform.scale(scale: scale, child: child),
        );
      },
      child: Text(widget.emoji, style: const TextStyle(fontSize: 40)),
    );
  }
}
