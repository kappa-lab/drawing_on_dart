import 'dart:math';
import 'dart:ui';
import 'foundation.dart';

FoundationWindow foundation;
num rad = 0.0;
const rectW = 50.0;

void main() {
  foundation = FoundationWindow(update);
}

void update(Canvas canv) {
  canv.drawColor(Color(0x0FFFFFFFF), BlendMode.screen);
  foundation.drawGrid();
  rad += 0.03;

  final path = Path();
  final x = sin(rad) * (FoundationWindow.logicalSize.width - rectW) / 2 +
      FoundationWindow.logicalSize.width / 2 -
      rectW / 2;
  final y = FoundationWindow.logicalSize.height / 2 - rectW / 2;
  
  path.addRect(Rect.fromLTWH(x, y, rectW, rectW));
  canv.drawPath(
      path,
      Paint()
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round
        ..color = Color(0xFFFF0000)
        ..style = PaintingStyle.fill);
}
