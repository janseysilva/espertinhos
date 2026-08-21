import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/age_group.dart';
import '../../services/music_service.dart';
import '../../services/tts_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_background.dart';
import '../../widgets/end_game_dialog.dart';
import '../../widgets/game_top_bar.dart';
import '../pintar/drawings.dart';

const _quebraCabecaPrompt = 'Toque em 2 peças para trocar de lugar';

int _minSwapsToSort(List<int> perm) {
  final n = perm.length;
  final visited = List.filled(n, false);
  var swaps = 0;
  for (var i = 0; i < n; i++) {
    if (visited[i] || perm[i] == i) continue;
    var cycleLen = 0;
    var j = i;
    while (!visited[j]) {
      visited[j] = true;
      j = perm[j];
      cycleLen++;
    }
    swaps += cycleLen - 1;
  }
  return swaps;
}

class QuebraCabecaScreen extends StatefulWidget {
  const QuebraCabecaScreen({super.key, required this.age});

  final AgeGroup age;

  @override
  State<QuebraCabecaScreen> createState() => _QuebraCabecaScreenState();
}

class _QuebraCabecaScreenState extends State<QuebraCabecaScreen> {
  late int gridN;
  late Drawing drawing;
  late List<int> pieceOrder;
  int swaps = 0;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    // 7-8 anos era 5x5 (25 peças) — difícil demais de acertar via trocas
    // pra uma criança, mesmo com o sombreado ajudando a diferenciar as
    // peças. Reduzido pra 4x4 (16), ainda o mais desafiador dos três mas
    // alcançável de verdade.
    gridN = switch (widget.age.level) { 0 => 2, 1 => 3, _ => 4 };
    final options = drawingsForAge(widget.age);
    drawing = options[Random().nextInt(options.length)];
    _shuffle();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (context.read<MusicService>().muted) return;
      context.read<TtsService>().speak(_quebraCabecaPrompt);
    });
  }

  @override
  void dispose() {
    context.read<TtsService>().stop();
    super.dispose();
  }

  void _shuffle() {
    final n = gridN * gridN;
    final random = Random();
    List<int> order;
    do {
      order = List.generate(n, (i) => i)..shuffle(random);
    } while (_minSwapsToSort(order) == 0 && n > 1);
    pieceOrder = order;
    swaps = 0;
    selectedIndex = null;
  }

  void _restart() {
    setState(_shuffle);
  }

  Future<void> _tapPiece(int index) async {
    if (selectedIndex == null) {
      setState(() => selectedIndex = index);
      return;
    }
    if (selectedIndex == index) {
      setState(() => selectedIndex = null);
      return;
    }
    setState(() {
      final tmp = pieceOrder[selectedIndex!];
      pieceOrder[selectedIndex!] = pieceOrder[index];
      pieceOrder[index] = tmp;
      swaps++;
      selectedIndex = null;
    });

    final solved = List.generate(pieceOrder.length, (i) => i == pieceOrder[i]).every((v) => v);
    if (solved) {
      // Terminar a figura (mesmo com várias trocas de tentativa e erro pelo
      // caminho) já dá nota máxima — pontuar pelo número de trocas exigia
      // acertar praticamente o número mínimo teórico (quase impossível pra
      // uma criança num tabuleiro maior), mesmo bug que a Memória tinha.
      final maxStars = widget.age.starsToAdvance;
      if (!mounted) return;
      await showEndGameDialog(
        context,
        gameId: 'quebra_cabeca',
        stars: maxStars,
        maxStars: maxStars,
        onReplay: _restart,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              children: [
                GameTopBar(progressLabel: 'Trocas: $swaps'),
                const SizedBox(height: 8),
                const Text(
                  'Toque em 2 peças para trocar de lugar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.black26, offset: Offset(0, 2))],
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final side = min(constraints.maxWidth, constraints.maxHeight);
                      return Center(
                        child: SizedBox(
                          width: side,
                          height: side,
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: gridN,
                              mainAxisSpacing: 2,
                              crossAxisSpacing: 2,
                            ),
                            itemCount: pieceOrder.length,
                            itemBuilder: (context, i) {
                              final full = side;
                              final cell = full / gridN;
                              final home = pieceOrder[i];
                              final row = home ~/ gridN;
                              final col = home % gridN;
                              return GestureDetector(
                                onTap: () => _tapPiece(i),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: selectedIndex == i ? AppColors.textDark : Colors.white,
                                      width: selectedIndex == i ? 3 : 1,
                                    ),
                                  ),
                                  child: ClipRect(
                                    child: OverflowBox(
                                      maxWidth: full,
                                      maxHeight: full,
                                      alignment: Alignment.topLeft,
                                      child: Transform.translate(
                                        offset: Offset(-col * cell, -row * cell),
                                        child: SizedBox(
                                          width: full,
                                          height: full,
                                          child: CustomPaint(
                                            painter: _PicturePainter(drawing: drawing),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Assim vai ficar:',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    shadows: [Shadow(color: Colors.black26, offset: Offset(0, 2))],
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 84,
                  height: 84,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: CustomPaint(painter: _PicturePainter(drawing: drawing)),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PicturePainter extends CustomPainter {
  _PicturePainter({required this.drawing});

  final Drawing drawing;

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..style = PaintingStyle.fill;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = Colors.black87;
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.white);
    for (var i = 0; i < drawing.parts.length; i++) {
      final path = drawing.parts[i](size);
      fill.color = AppColors.palette[i % AppColors.palette.length];
      canvas.drawPath(path, fill);
      canvas.drawPath(path, stroke);
    }
    // Sombreado por cima de TUDO (fundo e formas), não só o fundo — formas
    // grandes de cor sólida (ex: corpo de um robô ou carro) continuavam
    // idênticas entre si mesmo com o fundo em degradê, porque a tinta
    // sólida cobria o degradê por baixo. UM gradiente diagonal só não
    // bastava: ele varia junto com linha+coluna, então células "espelhadas"
    // (ex: linha 0 coluna 3 e linha 3 coluna 0) ficavam com sombra quase
    // igual — e como os desenhos costumam ser simétricos (rodas de carro,
    // olhos de robô, janelas de casa), esses pares continuavam parecidos.
    // Dois sombreados independentes (horizontal + vertical) resolvem: a
    // tonalidade de cada posição passa a depender de linha E coluna de
    // verdade, então não existem mais duas posições com a mesma sombra.
    final shadeH = Paint()
      ..blendMode = BlendMode.multiply
      ..shader = const LinearGradient(
        colors: [Color(0xFF8892B0), Colors.white],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, shadeH);
    final shadeV = Paint()
      ..blendMode = BlendMode.multiply
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFB0985C), Colors.white],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, shadeV);
  }

  @override
  bool shouldRepaint(covariant _PicturePainter oldDelegate) => oldDelegate.drawing != drawing;
}
