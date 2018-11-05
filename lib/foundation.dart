import 'dart:typed_data';
import 'dart:ui';
import 'dart:math';
//import 'package:tuple/tuple.dart';

class FoundationWindow {
  static final double devicePixelRatio = window.devicePixelRatio;
  static final Size physicalSize = window.physicalSize;
  static final Size logicalSize = physicalSize / devicePixelRatio;
  static final Float64List deviceTransform = new Float64List(16)
    ..[0] = window.devicePixelRatio
    ..[5] = window.devicePixelRatio
    ..[10] = 1.0
    ..[15] = 1.0;
  static final Rect paintBounds = Offset.zero & window.physicalSize;

  int _tick = 0;
  get tick => _tick;
  bool enableGrid;

  Image snapShot;
  Image _gridImage;
  Canvas _currentCanvas;

  Function(Canvas canvas) onUpdateFrame;

  FoundationWindow(this.onUpdateFrame) {
    window.onBeginFrame = onBeginFrame;
    window.scheduleFrame();
  }

  void onBeginFrame(Duration timeStamp) {
    _tick++;
    // PreProcess : Create Canvas
    final cr = CanvasRecorder();
    _currentCanvas = cr.canvas;

    // Draw by Outside
    onUpdateFrame(_currentCanvas);

    // PostProcess : Capture
    cr.endRecording();
    snapShot = cr.image;

    // composite
    final sceneBuilder = new SceneBuilder()
      ..pushTransform(deviceTransform)
      ..addPicture(Offset.zero, cr.picture)
      ..pop();
    window.render(sceneBuilder.build());
    window.scheduleFrame();
  }

  Image createGridImage() {
    final canv = CanvasRecorder();

    double size = max(logicalSize.width, logicalSize.height);
    var paint = Paint()
      ..color = Color.fromARGB(255, 0xFF, 0x99, 0x99)
      ..style = PaintingStyle.stroke;

    canv.canvas.drawRect(Rect.fromLTWH(0.0, 0.0, size, size), paint);

    var step = 10.0;
    int l = (size ~/ step);

    var path = Path();
    var pathR = Path();

    for (var i = 0; i < l; i++) {
      if (i % 5 == 0) {
        pathR.moveTo(step * i, 0.0);
        pathR.lineTo(step * i, size);
        pathR.moveTo(0.0, step * i);
        pathR.lineTo(size, step * i);
      } else {
        path.moveTo(step * i, 0.0);
        path.lineTo(step * i, size);
        path.moveTo(0.0, step * i);
        path.lineTo(size, step * i);
      }
    }
    canv.canvas.drawPath(pathR, paint);
    paint.color = Color.fromARGB(0xFF, 0xAA, 0xAA, 0xAA);
    canv.canvas.drawPath(path, paint);
    canv.endRecording();
    return canv.image;
  }

  void drawGrid([BlendMode blendMode = BlendMode.srcOver]) {
    if (_currentCanvas == null) return;
    if (_gridImage == null) _gridImage = createGridImage();

    _currentCanvas.drawImage(
        _gridImage, Offset.zero, Paint()..blendMode = blendMode);
  }
}

class CanvasRecorder {
  PictureRecorder recorder;
  Canvas canvas;
  Picture picture;
  Image image;

  CanvasRecorder() {
    recorder = new PictureRecorder();
    canvas = new Canvas(recorder, FoundationWindow.paintBounds);
  }

  void endRecording() {
    picture = recorder.endRecording();
    image = picture.toImage(FoundationWindow.physicalSize.width.toInt(),
        FoundationWindow.physicalSize.height.toInt());
  }

  void reborn(){
    recorder = new PictureRecorder();
    canvas = new Canvas(recorder, FoundationWindow.paintBounds);
    image = picture = null;
  }
}
