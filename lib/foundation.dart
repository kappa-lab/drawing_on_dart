import 'dart:typed_data';
import 'dart:ui';

class FoundationWindow {
  static final double devicePixelRatio = window.devicePixelRatio;
  static final Size physicalSize = window.physicalSize;
  static final Float64List deviceTransform = Float64List(16)
    ..[0] = window.devicePixelRatio
    ..[5] = window.devicePixelRatio
    ..[10] = 1.0
    ..[15] = 1.0;
  static final paintBounds = Offset.zero & window.physicalSize;

  int _tick = 0;
  get tick => _tick;

  Image? _snapShot;
  get snapShot => _snapShot;

  Function(Canvas canvas) onUpdateFrame;

  FoundationWindow(this.onUpdateFrame) {
    window.onBeginFrame = onBeginFrame;
    window.scheduleFrame();
  }

  void onBeginFrame(Duration timeStamp) {
    _tick++;
    // PreProcess : Create Canvas
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder, paintBounds);

    // Draw by Outside
    onUpdateFrame(canvas);

    // PostProcess : Capture
    final picture = recorder.endRecording();
    picture
        .toImage(physicalSize.width.toInt(), physicalSize.height.toInt())
        .then((value) => _snapShot = value,
            onError: (any) => {_snapShot = null});

    // composite
    final sceneBuilder = SceneBuilder()
      ..pushTransform(deviceTransform)
      ..addPicture(Offset.zero, picture)
      ..pop();
    window.render(sceneBuilder.build());
    window.scheduleFrame();
  }

  static void drawGuid(Canvas canv) {
    const size = 600.0;
    var paint = Paint()
      ..color = const Color.fromARGB(255, 0xFF, 22, 22)
      //..blendMode = BlendMode.multiply
      ..style = PaintingStyle.stroke;

    canv.drawRect(const Rect.fromLTWH(0.0, 0.0, size, size), paint);

    paint.color = const Color.fromARGB(255, 0xAA, 0xAA, 0xAA);
    var step = 10.0;
    var l = size / step;

    for (var i = 0; i < l; i++) {
      if (i % 5 == 0) {
        paint.color = const Color.fromARGB(255, 0xFF, 0x99, 0x99);
      } else {
        paint.color = const Color.fromARGB(255, 0xAA, 0xAA, 0xAA);
      }
      canv.drawLine(Offset(step * i, 0.0), Offset(step * i, size), paint);
      canv.drawLine(Offset(0.0, step * i), Offset(size, step * i), paint);
    }
  }
}
