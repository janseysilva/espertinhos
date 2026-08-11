// Common star-scoring helpers shared by every minigame.

/// Estrelas = número de rodadas certas — o total de estrelas possível bate
/// com o número de rodadas do jogo (ex: 8 rodadas, até 8 estrelas), pra
/// combinar com o contador "X / 8" mostrado durante a partida.
int starsFromRounds(int totalRounds, int mistakes) {
  final correct = totalRounds - mistakes;
  return correct.clamp(0, totalRounds);
}

int starsFromMistakes(int mistakes) {
  if (mistakes <= 0) return 8;
  if (mistakes == 1) return 7;
  if (mistakes == 2) return 6;
  if (mistakes == 3) return 5;
  if (mistakes == 4) return 4;
  if (mistakes == 5) return 3;
  if (mistakes == 6) return 2;
  return 1;
}

int starsFromEfficiency(int movesUsed, int minMoves) {
  if (minMoves <= 0 || movesUsed <= minMoves) return 8;
  final ratio = movesUsed / minMoves;
  if (ratio <= 1.15) return 7;
  if (ratio <= 1.3) return 6;
  if (ratio <= 1.5) return 5;
  if (ratio <= 1.7) return 4;
  if (ratio <= 2.0) return 3;
  if (ratio <= 2.5) return 2;
  return 1;
}
