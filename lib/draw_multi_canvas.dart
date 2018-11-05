import 'dart:math';
import 'dart:ui';
import 'foundation.dart';

FoundationWindow foundation;
num rad = 0.0;
const rectW = 50.0;
Image subCanvasImage;

void main() {
  foundation = FoundationWindow(update);
}

void update(Canvas canv) {
  canv.drawColor(Color(0x0FFFFFFFF), BlendMode.screen);
  foundation.drawGrid();
  rad += 0.03;

  var path = Path();
  var x = sin(rad) * (FoundationWindow.logicalSize.width - rectW) / 2 +
      FoundationWindow.logicalSize.width / 2 -
      rectW / 2;
  var y = FoundationWindow.logicalSize.height / 2 - rectW / 2;

  path.addRect(Rect.fromLTWH(x, y, rectW, rectW));
  canv.drawPath(
      path,
      Paint()
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round
        ..color = Color(0xFFFF0000)
        ..style = PaintingStyle.fill);


  // sub canvas
  var subCanv = CanvasRecorder();
  y = cos(rad) * (FoundationWindow.logicalSize.width - rectW) / 2 +
      FoundationWindow.logicalSize.width / 2 -
      rectW / 2;
  if(subCanvasImage!=null){
    subCanv.canvas.drawImage(subCanvasImage, Offset.zero, 
    Paint()
    ..color = Color.fromARGB(0xf0, 0xff, 0xff, 0xff)
    ..blendMode = BlendMode.lighten);
  }

  path = Path();
  path.addRect(Rect.fromLTWH(x, y + 120, rectW, rectW));

  subCanv.canvas.drawPath(
      path,
      Paint()
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round
        ..color = Color(0xFF0000FF)
        ..style = PaintingStyle.fill);

  subCanv.endRecording();
  subCanvasImage = subCanv.picture.toImage(FoundationWindow.logicalSize.width.toInt(),
      FoundationWindow.logicalSize.height.toInt());
  
  canv.drawImage(subCanvasImage, Offset.zero, Paint());
}
