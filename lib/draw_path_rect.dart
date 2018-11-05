import 'dart:typed_data';
import 'dart:ui';
import 'dart:math';
import 'foundation.dart';
import 'package:color/color.dart' show HslColor;

final rdm = Random();
FoundationWindow foundation;
List<ElasticRect> rect;
void main() {
  foundation = FoundationWindow(update);
  rect = [
    ElasticRect(Rect.fromLTWH(100.0, 100.0, 100.0, 100.0)),
    ElasticRect(Rect.fromLTWH(100.0, 300.0, 100.0, 100.0),
        rad: 0.8, h: 5.0, v: 20.0)
  ];
}

void update(Canvas canv) {
  canv.drawColor(Color(0x0FFFFFFFF), BlendMode.screen);
  final path = Path();
  rect.forEach((f) => path.addPath(f.getPaht(), Offset.zero));
  canv.drawPath(
      path,
      Paint()
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round
        ..color = Color(0xFFFF0000)
        ..style = PaintingStyle.fill);

  // FoundationWindow.drawGuid(canv);
}

class ElasticRect {
  Rect rect;

  double h;
  double v;
  double rad;
  ElasticRect(this.rect, {this.rad = 0.0, this.h = 10.0, this.v = 10.0});

  Path getPaht() {
    rad += 0.1;
    final s = sin(rad);
    final c = cos(rad);
    return Path()
      ..moveTo(rect.left - 1 + c * 2.0, rect.top - 1 + s * 2.0)
      ..cubicTo(
          rect.left + h + c * h / 2,
          rect.top - v + s * v / 2,
          rect.right - h + s * h / 2,
          rect.top - v + s * v / 2,
          rect.right - 2 + c * 4.0,
          rect.top - 2 + s * 4.0)
      ..cubicTo(
          rect.right + v + c * v / 2,
          rect.top + h + c * h / 2,
          rect.right + v + s * v / 2,
          rect.bottom - h + c * h / 2,
          rect.right - 1 + s * 2.0,
          rect.bottom - 1 + c * 2.0)
      ..cubicTo(
          rect.right - h + c * h / 2,
          rect.bottom + v + s * v / 2,
          rect.left + h + c * h / 2,
          rect.bottom + v + s * v / 2,
          rect.left - 1 + c * 2.0,
          rect.bottom - 1 + s * 2.0)
      ..cubicTo(
        rect.left - v + s * v / 2,
        rect.bottom - h + c * h / 2,
        rect.left - v + c * v / 2,
        rect.top + h + s * h / 2,
        rect.left - 1 + c * 2.0,
        rect.top - 1 + s * 2.0,
      )
      ..close();
  }
}
