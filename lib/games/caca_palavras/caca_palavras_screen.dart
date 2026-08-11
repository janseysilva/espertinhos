import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/age_group.dart';
import '../../models/scoring.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_background.dart';
import '../../widgets/end_game_dialog.dart';
import '../../widgets/feedback_flash.dart';
import '../../widgets/game_top_bar.dart';
import 'word_search_generator.dart';

const _pool2a4 = ['GATO', 'SOL', 'LUA', 'PATO', 'MESA', 'BOLA', 'RATO', 'CASA'];
const _pool5a6 = ['FLOR', 'LIVRO', 'PORTA', 'PEIXE', 'URSO', 'LEAO', 'NUVEM', 'CHUVA'];
const _pool7a8 = ['ESTRELA', 'MONTANHA', 'JARDIM', 'FLORESTA', 'GIRASSOL', 'ELEFANTE', 'FAMILIA', 'CACHORRO'];

class CacaPalavrasScreen extends StatefulWidget {
  const CacaPalavrasScreen({super.key, required this.age});

  final AgeGroup age;

  @override
  State<CacaPalavrasScreen> createState() => _CacaPalavrasScreenState();
}

class _CacaPalavrasScreenState extends State<CacaPalavrasScreen> {
  late WordSearchPuzzle puzzle;
  Point<int>? firstTap;
  int mistakes = 0;
  bool? feedback;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  void _setup() {
    final (n, wordCount, allowDiagonal, pool) = switch (widget.age.level) {
      0 => (6, 3, false, _pool2a4),
      1 => (8, 4, true, _pool5a6),
      _ => (10, 5, true, _pool7a8),
    };
    final chosen = (List<String>.from(pool)..shuffle()).take(wordCount).toList();
    puzzle = generateWordSearch(n: n, words: chosen, allowDiagonal: allowDiagonal);
    firstTap = null;
    mistakes = 0;
    feedback = null;
  }

  void _restart() => setState(_setup);

  List<Point<int>>? _straightPath(Point<int> a, Point<int> b) {
    final dr = b.x - a.x;
    final dc = b.y - a.y;
    if (dr != 0 && dc != 0 && dr.abs() != dc.abs()) return null;
    final steps = max(dr.abs(), dc.abs());
    final stepR = dr == 0 ? 0 : (dr ~/ dr.abs());
    final stepC = dc == 0 ? 0 : (dc ~/ dc.abs());
    return List.generate(steps + 1, (i) => Point(a.x + stepR * i, a.y + stepC * i));
  }

  bool _sameCells(List<Point<int>> a, List<Point<int>> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  Future<void> _tapCell(Point<int> p) async {
    if (firstTap == null) {
      setState(() => firstTap = p);
      return;
    }
    if (firstTap == p) {
      setState(() => firstTap = null);
      return;
    }
    final path = _straightPath(firstTap!, p);
    firstTap = null;

    PlacedWord? match;
    if (path != null) {
      for (final w in puzzle.words) {
        if (w.found) continue;
        if (_sameCells(w.cells, path) || _sameCells(w.cells, path.reversed.toList())) {
          match = w;
          break;
        }
      }
    }

    if (match != null) {
      final foundWord = match;
      setState(() {
        feedback = true;
        puzzle = WordSearchPuzzle(
          grid: puzzle.grid,
          n: puzzle.n,
          words: puzzle.words
              .map((w) => w.word == foundWord.word ? w.copyWith(found: true) : w)
              .toList(),
        );
      });
      await Future.delayed(const Duration(milliseconds: 450));
      if (!mounted) return;
      setState(() => feedback = null);
      if (puzzle.words.every((w) => w.found)) {
        final stars = starsFromMistakes(mistakes);
        await showEndGameDialog(context, gameId: 'caca_palavras', stars: stars, maxStars: 8, onReplay: _restart);
      }
    } else {
      mistakes++;
      setState(() => feedback = false);
      await Future.delayed(const Duration(milliseconds: 450));
      if (!mounted) return;
      setState(() => feedback = null);
    }
  }

  Color? _colorForCell(Point<int> p) {
    for (var i = 0; i < puzzle.words.length; i++) {
      final w = puzzle.words[i];
      if (w.found && w.cells.contains(p)) {
        return AppColors.palette[i % AppColors.palette.length].withValues(alpha: 0.55);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final foundCount = puzzle.words.where((w) => w.found).length;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  children: [
                    GameTopBar(progressLabel: '$foundCount/${puzzle.words.length}'),
                    const SizedBox(height: 8),
                    const Text(
                      'Toque na primeira e na última letra da palavra',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black26, offset: Offset(0, 2))],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: puzzle.words
                          .map(
                            (w) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: w.found ? AppColors.success : Colors.white.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                w.word,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                  decoration: w.found ? TextDecoration.lineThrough : null,
                                  color: w.found ? Colors.white : AppColors.textDark,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
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
                                crossAxisCount: puzzle.n,
                                mainAxisSpacing: 1,
                                crossAxisSpacing: 1,
                              ),
                              itemCount: puzzle.n * puzzle.n,
                              itemBuilder: (context, i) {
                                final row = i ~/ puzzle.n;
                                final col = i % puzzle.n;
                                final p = Point(row, col);
                                final isSelected = firstTap == p;
                                final foundColor = _colorForCell(p);
                                return GestureDetector(
                                  onTap: () => _tapCell(p),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: foundColor ?? (isSelected ? Colors.amber.shade100 : Colors.white),
                                      border: Border.all(
                                        color: isSelected ? Colors.black : Colors.black12,
                                        width: isSelected ? 2.5 : 1,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      puzzle.grid[row][col],
                                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                ],
              ),
            ),
              FeedbackFlash(correct: feedback),
            ],
          ),
        ),
      ),
    );
  }
}
