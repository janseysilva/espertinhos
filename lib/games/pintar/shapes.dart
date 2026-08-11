import 'dart:math';
import 'dart:ui';

Path circlePath(Size s, double cx, double cy, double r) {
  final minDim = min(s.width, s.height);
  return Path()
    ..addOval(Rect.fromCircle(center: Offset(cx * s.width, cy * s.height), radius: r * minDim));
}

Path ovalPath(Size s, double cx, double cy, double w, double h) {
  return Path()
    ..addOval(Rect.fromCenter(center: Offset(cx * s.width, cy * s.height), width: w * s.width, height: h * s.height));
}

Path rectPath(Size s, double l, double t, double r, double b, {double radius = 0}) {
  final rect = Rect.fromLTRB(l * s.width, t * s.height, r * s.width, b * s.height);
  final minDim = min(s.width, s.height);
  return Path()..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius * minDim)));
}

Path polyPath(Size s, List<Offset> fracPoints) {
  final path = Path();
  for (var i = 0; i < fracPoints.length; i++) {
    final p = Offset(fracPoints[i].dx * s.width, fracPoints[i].dy * s.height);
    if (i == 0) {
      path.moveTo(p.dx, p.dy);
    } else {
      path.lineTo(p.dx, p.dy);
    }
  }
  path.close();
  return path;
}

Path starPath(Size s, {double cx = 0.5, double cy = 0.5, double outer = 0.45, double inner = 0.2}) {
  final minDim = min(s.width, s.height);
  final center = Offset(cx * s.width, cy * s.height);
  final path = Path();
  for (var i = 0; i < 10; i++) {
    final angle = (pi / 5) * i - pi / 2;
    final r = (i.isEven ? outer : inner) * minDim;
    final p = Offset(center.dx + r * cos(angle), center.dy + r * sin(angle));
    if (i == 0) {
      path.moveTo(p.dx, p.dy);
    } else {
      path.lineTo(p.dx, p.dy);
    }
  }
  path.close();
  return path;
}

Path heartPath(Size s) {
  final w = s.width, h = s.height;
  final path = Path();
  path.moveTo(w / 2, h * 0.85);
  path.cubicTo(-w * 0.05, h * 0.5, w * 0.15, h * 0.05, w / 2, h * 0.32);
  path.cubicTo(w * 0.85, h * 0.05, w * 1.05, h * 0.5, w / 2, h * 0.85);
  path.close();
  return path;
}

Path raysPath(Size s, {double cx = 0.5, double cy = 0.5, double innerR = 0.3, double outerR = 0.48, int count = 8}) {
  final minDim = min(s.width, s.height);
  final center = Offset(cx * s.width, cy * s.height);
  final path = Path();
  for (var i = 0; i < count; i++) {
    final angle = (2 * pi / count) * i;
    final dir = Offset(cos(angle), sin(angle));
    final perp = Offset(-dir.dy, dir.dx);
    final base1 = center + dir * innerR * minDim + perp * 0.035 * minDim;
    final base2 = center + dir * innerR * minDim - perp * 0.035 * minDim;
    final tip = center + dir * outerR * minDim;
    path.moveTo(base1.dx, base1.dy);
    path.lineTo(tip.dx, tip.dy);
    path.lineTo(base2.dx, base2.dy);
    path.close();
  }
  return path;
}

Path unionOvals(Size s, List<(double cx, double cy, double w, double h)> ovals) {
  final path = Path();
  for (final o in ovals) {
    path.addOval(Rect.fromCenter(
      center: Offset(o.$1 * s.width, o.$2 * s.height),
      width: o.$3 * s.width,
      height: o.$4 * s.height,
    ));
  }
  return path;
}

Path unionRects(Size s, List<(double l, double t, double r, double b)> rects, {double radius = 0}) {
  final path = Path();
  final minDim = min(s.width, s.height);
  for (final rc in rects) {
    final rect = Rect.fromLTRB(rc.$1 * s.width, rc.$2 * s.height, rc.$3 * s.width, rc.$4 * s.height);
    path.addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius * minDim)));
  }
  return path;
}

Path unionPolys(Size s, List<List<Offset>> polys) {
  final path = Path();
  for (final pts in polys) {
    for (var i = 0; i < pts.length; i++) {
      final p = Offset(pts[i].dx * s.width, pts[i].dy * s.height);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    path.close();
  }
  return path;
}
