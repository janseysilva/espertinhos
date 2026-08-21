import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/age_group.dart';
import '../../services/music_service.dart';
import '../../services/tts_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_background.dart';
import '../../widgets/end_game_dialog.dart';
import '../../widgets/game_top_bar.dart';
import '../../widgets/squishy_button.dart';
import 'drawings.dart';

const _choosePrompt = 'Escolha um desenho para pintar';
const _paintPrompt = 'Toque nas partes do desenho para escolher a cor';

const _paintColors = <Color>[
  Color(0xFFEF5350),
  Color(0xFFFF7043),
  Color(0xFFFFC107),
  Color(0xFF66BB6A),
  Color(0xFF00BFA5),
  Color(0xFF2196F3),
  Color(0xFF7C4DFF),
  Color(0xFFFF4081),
  Color(0xFF8D6E63),
  Color(0xFF212121),
];

class PintarScreen extends StatefulWidget {
  const PintarScreen({super.key, required this.age});

  final AgeGroup age;

  @override
  State<PintarScreen> createState() => _PintarScreenState();
}

class _PintarScreenState extends State<PintarScreen> {
  Drawing? selected;
  late List<Color?> partColors;
  Color currentColor = _paintColors.first;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _speak(_choosePrompt));
  }

  void _speak(String text) {
    if (!mounted) return;
    if (context.read<MusicService>().muted) return;
    context.read<TtsService>().speak(text);
  }

  @override
  void dispose() {
    context.read<TtsService>().stop();
    super.dispose();
  }

  void _select(Drawing d) {
    setState(() {
      selected = d;
      partColors = List<Color?>.filled(d.parts.length, null);
    });
    _speak(_paintPrompt);
  }

  void _finish() {
    // Pintar não tem "erro" possível (é livre), então sempre dá nota
    // máxima — mas a nota máxima acompanha a exigência da faixa etária,
    // pra bater com o "X de X estrelas" mostrado nos outros jogos.
    final stars = widget.age.starsToAdvance;
    showEndGameDialog(
      context,
      gameId: 'pintar',
      stars: stars,
      maxStars: stars,
      onReplay: () => setState(() => selected = null),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (selected == null) {
      final options = drawingsForAge(widget.age);
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: AppBackground(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                children: [
                  const GameTopBar(),
                  const SizedBox(height: 12),
                  const Text(
                    'Escolha um desenho para pintar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black26, offset: Offset(0, 2))],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: options.length,
                      itemBuilder: (context, i) {
                        final d = options[i];
                        return SquishyButton(
                          borderRadius: 20,
                          onTap: () => _select(d),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(d.emoji, style: const TextStyle(fontSize: 40)),
                              const SizedBox(height: 8),
                              Text(
                                d.title,
                                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
                              ),
                            ],
                          ),
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

    final drawing = selected!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              children: [
                GameTopBar(
                  progressLabel: drawing.title,
                  onBack: () => setState(() => selected = null),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final size = Size(constraints.maxWidth, constraints.maxHeight);
                        return GestureDetector(
                          onTapUp: (details) {
                            for (var i = drawing.parts.length - 1; i >= 0; i--) {
                              if (drawing.parts[i](size).contains(details.localPosition)) {
                                setState(() => partColors[i] = currentColor);
                                break;
                              }
                            }
                          },
                          child: CustomPaint(
                            size: size,
                            painter: _ColoringPainter(parts: drawing.parts, colors: partColors),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 56,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _paintColors.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, i) {
                      final c = _paintColors[i];
                      final isSelected = c == currentColor;
                      return GestureDetector(
                        onTap: () => setState(() => currentColor = c),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 120),
                          width: isSelected ? 48 : 40,
                          height: isSelected ? 48 : 40,
                          decoration: BoxDecoration(
                            color: c,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? AppColors.textDark : Colors.white,
                              width: 3,
                            ),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), offset: const Offset(0, 3))],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: SquishyButton(
                    color: AppColors.bigRed,
                    shadowColor: AppColors.bigRedShadow,
                    borderRadius: 999,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    onTap: _finish,
                    child: const Center(
                      child: Text(
                        'PRONTO!',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
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

class _ColoringPainter extends CustomPainter {
  _ColoringPainter({required this.parts, required this.colors});

  final List<Path Function(Size)> parts;
  final List<Color?> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..style = PaintingStyle.fill;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = Colors.black87;

    for (var i = 0; i < parts.length; i++) {
      final path = parts[i](size);
      fill.color = colors[i] ?? Colors.white;
      canvas.drawPath(path, fill);
      canvas.drawPath(path, stroke);
    }
  }

  @override
  bool shouldRepaint(covariant _ColoringPainter oldDelegate) => true;
}
