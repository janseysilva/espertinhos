import 'dart:ui';

import '../../models/age_group.dart';
import 'shapes.dart';

typedef PathBuilder = Path Function(Size size);

class Drawing {
  const Drawing({required this.id, required this.title, required this.emoji, required this.parts});

  final String id;
  final String title;
  final String emoji;
  final List<PathBuilder> parts;
}

final _coracao = Drawing(id: 'coracao', title: 'Coração', emoji: '❤️', parts: [heartPath]);

final _estrela = Drawing(id: 'estrela', title: 'Estrela', emoji: '⭐', parts: [(s) => starPath(s)]);

final _sol = Drawing(
  id: 'sol',
  title: 'Sol',
  emoji: '☀️',
  parts: [(s) => raysPath(s), (s) => circlePath(s, 0.5, 0.5, 0.28)],
);

final _lua = Drawing(
  id: 'lua',
  title: 'Lua',
  emoji: '🌙',
  parts: [
    (s) => Path.combine(
          PathOperation.difference,
          circlePath(s, 0.5, 0.5, 0.38),
          circlePath(s, 0.68, 0.4, 0.32),
        ),
  ],
);

final _flor = Drawing(
  id: 'flor',
  title: 'Flor',
  emoji: '🌸',
  parts: [
    (s) => unionOvals(s, [
          (0.5, 0.28, 0.34, 0.34),
          (0.5, 0.72, 0.34, 0.34),
          (0.28, 0.5, 0.34, 0.34),
          (0.72, 0.5, 0.34, 0.34),
        ]),
    (s) => circlePath(s, 0.5, 0.5, 0.14),
  ],
);

final _balao = Drawing(
  id: 'balao',
  title: 'Balão',
  emoji: '🎈',
  parts: [
    (s) => ovalPath(s, 0.5, 0.4, 0.5, 0.58),
    (s) => polyPath(s, const [Offset(0.47, 0.68), Offset(0.53, 0.68), Offset(0.5, 0.75)]),
  ],
);

final _peixe = Drawing(
  id: 'peixe',
  title: 'Peixe',
  emoji: '🐠',
  parts: [
    (s) => ovalPath(s, 0.42, 0.5, 0.52, 0.34),
    (s) => polyPath(s, const [Offset(0.66, 0.5), Offset(0.92, 0.32), Offset(0.92, 0.68)]),
    (s) => circlePath(s, 0.26, 0.46, 0.035),
  ],
);

final _borboleta = Drawing(
  id: 'borboleta',
  title: 'Borboleta',
  emoji: '🦋',
  parts: [
    (s) => unionOvals(s, [(0.28, 0.34, 0.32, 0.28), (0.32, 0.62, 0.24, 0.22)]),
    (s) => unionOvals(s, [(0.72, 0.34, 0.32, 0.28), (0.68, 0.62, 0.24, 0.22)]),
    (s) => ovalPath(s, 0.5, 0.5, 0.06, 0.5),
  ],
);

final _arvore = Drawing(
  id: 'arvore',
  title: 'Árvore',
  emoji: '🌳',
  parts: [
    (s) => rectPath(s, 0.44, 0.6, 0.56, 0.88),
    (s) => unionOvals(s, [
          (0.5, 0.32, 0.5, 0.42),
          (0.32, 0.42, 0.34, 0.34),
          (0.68, 0.42, 0.34, 0.34),
        ]),
  ],
);

final _foguete = Drawing(
  id: 'foguete',
  title: 'Foguete',
  emoji: '🚀',
  parts: [
    (s) => unionPolys(s, [
          const [Offset(0.5, 0.08), Offset(0.36, 0.32), Offset(0.64, 0.32)],
        ]).let((p) => p..addRRect(RRect.fromRectAndRadius(
              Rect.fromLTRB(0.36 * s.width, 0.3 * s.height, 0.64 * s.width, 0.72 * s.height),
              Radius.circular(0.06 * s.width),
            ))),
    (s) => unionPolys(s, [
          const [Offset(0.36, 0.55), Offset(0.18, 0.78), Offset(0.36, 0.72)],
        ]),
    (s) => unionPolys(s, [
          const [Offset(0.64, 0.55), Offset(0.82, 0.78), Offset(0.64, 0.72)],
        ]),
    (s) => circlePath(s, 0.5, 0.44, 0.08),
  ],
);

final _casa = Drawing(
  id: 'casa',
  title: 'Casa',
  emoji: '🏠',
  parts: [
    (s) => rectPath(s, 0.2, 0.45, 0.8, 0.85),
    (s) => polyPath(s, const [Offset(0.14, 0.45), Offset(0.5, 0.14), Offset(0.86, 0.45)]),
    (s) => rectPath(s, 0.44, 0.6, 0.56, 0.85),
    (s) => unionRects(s, [(0.28, 0.53, 0.4, 0.64), (0.6, 0.53, 0.72, 0.64)]),
  ],
);

final _robo = Drawing(
  id: 'robo',
  title: 'Robô',
  emoji: '🤖',
  parts: [
    (s) => rectPath(s, 0.35, 0.12, 0.65, 0.34, radius: 0.05),
    (s) => rectPath(s, 0.28, 0.36, 0.72, 0.74, radius: 0.05),
    (s) => unionOvals(s, [(0.44, 0.22, 0.08, 0.08), (0.56, 0.22, 0.08, 0.08)]),
    (s) => unionRects(s, [(0.14, 0.4, 0.28, 0.5), (0.72, 0.4, 0.86, 0.5)], radius: 0.04),
    (s) => unionRects(s, [(0.34, 0.76, 0.46, 0.9), (0.54, 0.76, 0.66, 0.9)], radius: 0.03),
  ],
);

final _dinossauro = Drawing(
  id: 'dinossauro',
  title: 'Dinossauro',
  emoji: '🦕',
  parts: [
    (s) => ovalPath(s, 0.48, 0.55, 0.56, 0.36),
    (s) => polyPath(s, const [Offset(0.78, 0.58), Offset(0.94, 0.42), Offset(0.86, 0.68)]),
    (s) => unionRects(s, [(0.32, 0.72, 0.4, 0.86), (0.56, 0.72, 0.64, 0.86)]),
    (s) => unionPolys(s, [
          [const Offset(0.34, 0.4), const Offset(0.4, 0.26), const Offset(0.46, 0.4)],
          [const Offset(0.46, 0.4), const Offset(0.52, 0.24), const Offset(0.58, 0.4)],
        ]),
    (s) => circlePath(s, 0.24, 0.46, 0.14),
  ],
);

final _carro = Drawing(
  id: 'carro',
  title: 'Carro',
  emoji: '🚗',
  parts: [
    (s) => rectPath(s, 0.12, 0.5, 0.88, 0.72, radius: 0.08),
    (s) => polyPath(s, const [
          Offset(0.28, 0.5),
          Offset(0.38, 0.32),
          Offset(0.62, 0.32),
          Offset(0.72, 0.5),
        ]),
    (s) => unionOvals(s, [(0.28, 0.74, 0.16, 0.16), (0.72, 0.74, 0.16, 0.16)]),
    (s) => unionRects(s, [(0.4, 0.36, 0.6, 0.5)]),
  ],
);

final _allDrawings = <Drawing>[
  _coracao, _estrela, _sol, _lua, _flor, _balao, _peixe, _borboleta,
  _arvore, _foguete, _casa, _robo, _dinossauro, _carro,
];

Drawing drawingById(String id) => _allDrawings.firstWhere((d) => d.id == id);

List<Drawing> drawingsForAge(AgeGroup age) {
  final ids = switch (age.level) {
    0 => ['coracao', 'estrela', 'sol', 'lua', 'flor', 'balao', 'peixe', 'borboleta'],
    1 => ['sol', 'flor', 'borboleta', 'peixe', 'arvore', 'balao', 'estrela', 'lua'],
    _ => ['casa', 'robo', 'dinossauro', 'carro', 'arvore', 'foguete', 'borboleta', 'peixe'],
  };
  return ids.map(drawingById).toList();
}

extension _Let<T> on T {
  R let<R>(R Function(T) f) => f(this);
}
