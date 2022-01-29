// HOW TO RUN -> READEME.md
import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const DrawCircle3());
  }
}

class DrawCircle3 extends StatelessWidget {
  const DrawCircle3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _Content();
  }
}

class _Content extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ContentState();
}

class _ContentState extends State<_Content> with TickerProviderStateMixin {
  late AnimationController animCtl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
    debugLabel: 'anim',
  );
  late CurvedAnimation curve =
      CurvedAnimation(parent: animCtl, curve: Curves.linear);

  late Animation<double> anim;
  late int _tick;
  late Point core;
  late List<Particle> perticles;
  late _MyPainter painter;
  @override
  Widget build(BuildContext context) {
    if (core != null && perticles != null && painter != null)
      painter.update(perticles, core);
    painter = _MyPainter(perticles, core);
    return Scaffold(
      backgroundColor: const Color.fromARGB(0, 255, 255, 255),
      appBar: AppBar(
        title: const Text('App Name'),
      ),
      body: Center(
          child: Center(
              child: CustomPaint(
        foregroundPainter: painter,
        willChange: true,
      ))),
      floatingActionButton: FloatingActionButton(
        onPressed: _reset,
        child: const Icon(Icons.replay),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    anim = Tween(end: pi * 8.0, begin: 0.0).animate(curve)
      ..addListener(_update);
    _createTarget();

    _reset();
    painter = _MyPainter(perticles, core);
  }

  void _createTarget() {
    var range = 200.0;
    var r = Random();
    core = Point(r.nextDouble() * range - range / 2.0,
        r.nextDouble() * range - range / 2.0);
  }

  void _update() {
    // print("anim.v ${sin(anim.value)}");
    if (anim.isCompleted) {
      print("anim.isCompleted ${anim.value}, ${sin(anim.value)}");
      _createTarget();
      _reset();
      // animCtl.forward(from: 0.0);
    }

    setState(() {
      perticles = perticles.map((f) => motion1(f)).toList();
    });
  }

  void _reset() {
    setState(() {
      perticles = [];
      for (var i = 0; i < 20; i++) {
        perticles.add(Particle.random());
        // perticles.add(Particle(Point(100.0, 0.0), Point(0, 10.0), 0.1));
      }
      _createTarget();
      _tick = 0;
    });
    animCtl.forward(from: 0.0);
    animCtl.repeat();
    // List<Point> d = [Point(4, 0), Point(8, 0)];
    // print(d);
    // d = d.map((f) => Point(f.x * 2, 1)).toList();
    // print(d);
  }

  Particle motion1(Particle pt) {
    var f = Point((core.x - pt.pos.x) / 100.0, (core.y - pt.pos.y) / 100.0);
    var f2 = Point(pt.vec.x + f.x, pt.vec.y + f.y);
    return Particle.move(pt.pos, f2, pt.velocity);
  }
}

class _MyPainter extends CustomPainter {
  late int tick;
  Point core;
  List<Particle> points;
  _MyPainter(this.points, this.core);
  void update(List<Particle> points, Point core) {
    this.points = points;
    this.core = core;
  }

  @override
  void paint(Canvas canv, Size size) {
    _drawGuid(canv);
    _draw(canv, Particle(core, core, 0.0), Colors.black);
    points.forEach((f) => _draw(canv, f));
  }

  void _drawGuid(Canvas canv) {
    const size = 400.0;
    var paint = Paint()
      ..color = const Color.fromARGB(255, 0xFF, 22, 22)
      //..blendMode = BlendMode.multiply
      ..style = PaintingStyle.stroke;

    canv.drawRect(const Rect.fromLTWH(-size / 2, -size / 2, size, size), paint);

    paint.color = const Color.fromARGB(255, 0xAA, 0xAA, 0xAA);
    var step = 10;
    var l = size / step;

    for (var i = 0; i < l; i++) {
      if (i % 5 == 0) {
        paint.color = const Color.fromARGB(255, 0x00, 0x00, 0x00);
      } else {
        paint.color = const Color.fromARGB(255, 0xAA, 0xAA, 0xAA);
      }
      canv.drawLine(Offset(-size / 2 + step * i, -size / 2),
          Offset(-size / 2 + step * i, size / 2), paint);
      canv.drawLine(Offset(-size / 2, -size / 2 + step * i),
          Offset(size / 2, -size / 2 + step * i), paint);
    }
  }

  void _draw(Canvas canv, Particle pt, [Color color = Colors.blue]) {
    canv.drawCircle(
      Offset(pt.pos.x.toDouble(), pt.pos.y.toDouble()),
      8.0,
      Paint()
        ..color = color
        ..blendMode = BlendMode.multiply
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Particle {
  Point pos;
  Point vec;
  double velocity;
  static var r = Random();

  Particle(this.pos, this.vec, this.velocity);

  Particle.zero()
      : pos = const Point(0.0, 0.0),
        vec = const Point(0.0, 0.0),
        velocity = 0.0;

  Particle.random()
      : pos = Point(r.nextDouble() * 100.0 + 50, r.nextDouble() * 40 - 20.0),
        vec = Point(r.nextDouble() * 4.0 - 10.0, r.nextDouble() * 4.0 - 20.0),
        velocity = r.nextDouble() * 0.1 + 0.05;
  // perticles.add(Particle(Point(100.0, 0.0), Point(0, 10.0), 0.1));

  Particle.move(this.pos, this.vec, this.velocity) {
    pos = Point(pos.x + (vec.x * velocity), pos.y + (vec.y * velocity));
  }

  Particle move() {
    return Particle(
        Point(pos.x + (vec.x * velocity), pos.y + (vec.y * velocity)),
        this.vec,
        this.velocity);
  }
}
