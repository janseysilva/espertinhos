import 'dart:math';

class PlacedWord {
  const PlacedWord({required this.word, required this.cells, this.found = false});

  final String word;
  final List<Point<int>> cells;
  final bool found;

  PlacedWord copyWith({bool? found}) => PlacedWord(word: word, cells: cells, found: found ?? this.found);
}

class WordSearchPuzzle {
  const WordSearchPuzzle({required this.grid, required this.words, required this.n});

  final List<List<String>> grid;
  final List<PlacedWord> words;
  final int n;
}

const _alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
const _allDirections = <(int, int)>[
  (0, 1), (1, 0), (0, -1), (-1, 0), (1, 1), (1, -1), (-1, 1), (-1, -1),
];
const _straightDirections = <(int, int)>[(0, 1), (1, 0), (0, -1), (-1, 0)];

WordSearchPuzzle generateWordSearch({
  required int n,
  required List<String> words,
  required bool allowDiagonal,
}) {
  final random = Random();
  for (var globalAttempt = 0; globalAttempt < 80; globalAttempt++) {
    final result = _tryOnce(n, words, random, allowDiagonal);
    if (result != null) return result;
  }
  return _tryOnce(n, words, random, allowDiagonal, forceFit: true)!;
}

WordSearchPuzzle? _tryOnce(
  int n,
  List<String> words,
  Random random,
  bool allowDiagonal, {
  bool forceFit = false,
}) {
  final grid = List.generate(n, (_) => List<String?>.filled(n, null));
  final placed = <PlacedWord>[];
  final directions = allowDiagonal ? _allDirections : _straightDirections;

  for (final w in words) {
    var ok = false;
    for (var attempt = 0; attempt < 300; attempt++) {
      final dir = directions[random.nextInt(directions.length)];
      final dr = dir.$1, dc = dir.$2;
      final startRow = random.nextInt(n);
      final startCol = random.nextInt(n);
      final endRow = startRow + dr * (w.length - 1);
      final endCol = startCol + dc * (w.length - 1);
      if (endRow < 0 || endRow >= n || endCol < 0 || endCol >= n) continue;

      final cells = List.generate(w.length, (i) => Point(startRow + dr * i, startCol + dc * i));
      var conflict = false;
      for (var i = 0; i < w.length; i++) {
        final existing = grid[cells[i].x][cells[i].y];
        if (existing != null && existing != w[i]) {
          conflict = true;
          break;
        }
      }
      if (conflict) continue;

      for (var i = 0; i < w.length; i++) {
        grid[cells[i].x][cells[i].y] = w[i];
      }
      placed.add(PlacedWord(word: w, cells: cells));
      ok = true;
      break;
    }
    if (!ok && !forceFit) return null;
  }

  for (var r = 0; r < n; r++) {
    for (var c = 0; c < n; c++) {
      grid[r][c] ??= _alphabet[random.nextInt(_alphabet.length)];
    }
  }

  return WordSearchPuzzle(
    grid: grid.map((row) => row.map((c) => c!).toList()).toList(),
    words: placed,
    n: n,
  );
}
