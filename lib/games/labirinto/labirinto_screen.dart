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

const _labirintoPrompt = 'Leve o coelhinho até a bandeira';

class _Cell {
  bool up = false;
  bool down = false;
  bool left = false;
  bool right = false;
}

List<List<_Cell>> _generateMaze(int n) {
  final grid = List.generate(n, (_) => List.generate(n, (_) => _Cell()));
  final visited = List.generate(n, (_) => List.filled(n, false));
  final random = Random();
  final stack = <Point<int>>[const Point(0, 0)];
  visited[0][0] = true;

  while (stack.isNotEmpty) {
    final current = stack.last;
    final neighbors = <(Point<int>, String)>[];
    if (current.y > 0 && !visited[current.y - 1][current.x]) {
      neighbors.add((Point(current.x, current.y - 1), 'up'));
    }
    if (current.y < n - 1 && !visited[current.y + 1][current.x]) {
      neighbors.add((Point(current.x, current.y + 1), 'down'));
    }
    if (current.x > 0 && !visited[current.y][current.x - 1]) {
      neighbors.add((Point(current.x - 1, current.y), 'left'));
    }
    if (current.x < n - 1 && !visited[current.y][current.x + 1]) {
      neighbors.add((Point(current.x + 1, current.y), 'right'));
    }
    if (neighbors.isEmpty) {
      stack.removeLast();
      continue;
    }
    final (next, dir) = neighbors[random.nextInt(neighbors.length)];
    switch (dir) {
      case 'up':
        grid[current.y][current.x].up = true;
        grid[next.y][next.x].down = true;
      case 'down':
        grid[current.y][current.x].down = true;
        grid[next.y][next.x].up = true;
      case 'left':
        grid[current.y][current.x].left = true;
        grid[next.y][next.x].right = true;
      case 'right':
        grid[current.y][current.x].right = true;
        grid[next.y][next.x].left = true;
    }
    visited[next.y][next.x] = true;
    stack.add(next);
  }
  return grid;
}

class LabirintoScreen extends StatefulWidget {
  const LabirintoScreen({super.key, required this.age});

  final AgeGroup age;

  @override
  State<LabirintoScreen> createState() => _LabirintoScreenState();
}

class _LabirintoScreenState extends State<LabirintoScreen> {
  late int gridN;
  late int totalRounds;
  int round = 0;
  late List<List<_Cell>> maze;
  late int playerRow;
  late int playerCol;
  late int goalRow;
  late int goalCol;

  @override
  void initState() {
    super.initState();
    gridN = switch (widget.age.level) { 0 => 3, 1 => 5, _ => 7 };
    totalRounds = widget.age.starsToAdvance;
    _newMaze();
  }

  @override
  void dispose() {
    context.read<TtsService>().stop();
    super.dispose();
  }

  void _newMaze() {
    maze = _generateMaze(gridN);
    playerRow = 0;
    playerCol = 0;
    goalRow = gridN - 1;
    goalCol = gridN - 1;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (context.read<MusicService>().muted) return;
      context.read<TtsService>().speak(_labirintoPrompt);
    });
  }

  void _restart() {
    setState(() {
      round = 0;
      _newMaze();
    });
  }

  Future<void> _move(int dr, int dc, bool Function(_Cell) canGo) async {
    final cell = maze[playerRow][playerCol];
    if (!canGo(cell)) return;
    setState(() {
      playerRow += dr;
      playerCol += dc;
    });
    if (playerRow == goalRow && playerCol == goalCol) {
      if (round + 1 >= totalRounds) {
        final maxStars = widget.age.starsToAdvance;
        if (!mounted) return;
        await showEndGameDialog(
          context,
          gameId: 'labirinto',
          stars: maxStars,
          maxStars: maxStars,
          onReplay: _restart,
        );
      } else {
        await Future.delayed(const Duration(milliseconds: 400));
        if (!mounted) return;
        setState(() {
          round++;
          _newMaze();
        });
      }
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
                GameTopBar(progressLabel: '${round + 1} / $totalRounds', progress: (round + 1) / totalRounds),
                const SizedBox(height: 8),
                const Text(
                  'Leve o coelhinho até a bandeira',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.black26, offset: Offset(0, 2))],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final side = min(constraints.maxWidth, constraints.maxHeight);
                      final cellSize = side / gridN;
                      return Center(
                        child: SizedBox(
                          width: side,
                          height: side,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: CustomPaint(painter: _MazePainter(maze: maze, gridN: gridN)),
                              ),
                              AnimatedPositioned(
                                duration: const Duration(milliseconds: 160),
                                curve: Curves.easeOut,
                                left: goalCol * cellSize,
                                top: goalRow * cellSize,
                                width: cellSize,
                                height: cellSize,
                                child: Center(child: Text('🚩', style: TextStyle(fontSize: cellSize * 0.55))),
                              ),
                              AnimatedPositioned(
                                duration: const Duration(milliseconds: 140),
                                curve: Curves.easeOut,
                                left: playerCol * cellSize,
                                top: playerRow * cellSize,
                                width: cellSize,
                                height: cellSize,
                                child: Center(child: Text('🐰', style: TextStyle(fontSize: cellSize * 0.6))),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                _DPad(
                  onUp: () => _move(-1, 0, (c) => c.up),
                  onDown: () => _move(1, 0, (c) => c.down),
                  onLeft: () => _move(0, -1, (c) => c.left),
                  onRight: () => _move(0, 1, (c) => c.right),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MazePainter extends CustomPainter {
  _MazePainter({required this.maze, required this.gridN});

  final List<List<_Cell>> maze;
  final int gridN;

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / gridN;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(12)),
      Paint()..color = Colors.white.withValues(alpha: 0.85),
    );
    final wall = Paint()
      ..color = AppColors.textDark
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawRect(Offset.zero & size, Paint()
      ..color = AppColors.textDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3);

    for (var r = 0; r < gridN; r++) {
      for (var c = 0; c < gridN; c++) {
        final cellData = maze[r][c];
        final x = c * cell;
        final y = r * cell;
        if (!cellData.right && c < gridN - 1) {
          canvas.drawLine(Offset(x + cell, y), Offset(x + cell, y + cell), wall);
        }
        if (!cellData.down && r < gridN - 1) {
          canvas.drawLine(Offset(x, y + cell), Offset(x + cell, y + cell), wall);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MazePainter oldDelegate) => oldDelegate.maze != maze;
}

class _DPad extends StatelessWidget {
  const _DPad({required this.onUp, required this.onDown, required this.onLeft, required this.onRight});

  final VoidCallback onUp;
  final VoidCallback onDown;
  final VoidCallback onLeft;
  final VoidCallback onRight;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _DPadButton(icon: Icons.keyboard_arrow_up_rounded, onTap: onUp),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DPadButton(icon: Icons.keyboard_arrow_left_rounded, onTap: onLeft),
            const SizedBox(width: 56),
            _DPadButton(icon: Icons.keyboard_arrow_right_rounded, onTap: onRight),
          ],
        ),
        const SizedBox(height: 6),
        _DPadButton(icon: Icons.keyboard_arrow_down_rounded, onTap: onDown),
      ],
    );
  }
}

class _DPadButton extends StatelessWidget {
  const _DPadButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.9),
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(icon, size: 30, color: AppColors.accent),
        ),
      ),
    );
  }
}
