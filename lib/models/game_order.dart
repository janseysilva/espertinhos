/// Ordem das fases — define em que sequência os jogos são liberados.
/// Precisa bater com a ordem de `kGames` em `screens/home_screen.dart`.
/// O jogo especial ([kSpecialGameId]) fica DE FORA dessa lista de propósito
/// — ele não é liberado por sequência, e sim ao bater a meta de estrelas
/// vitalícias (ver `AppState.isUnlocked`).
const List<String> kGameOrder = [
  'cores_formas',
  'contando',
  'memoria',
  'alfabeto',
  'matematica',
  'sequencia',
  'pintar',
  'ache_diferente',
  'maior_menor',
  'opostos',
  'quebra_cabeca',
  'caca_palavras',
  'labirinto',
  'sons_bichos',
];

/// Id do jogo especial, desbloqueado só com estrelas vitalícias suficientes.
const kSpecialGameId = 'familia';
