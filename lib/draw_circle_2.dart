import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'dart:math';

class DrawCircle2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: new Color(0xFFEEEEEE),
      body: _Content(),
    );
  }
}

class _Content extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ContentState();
}

class _ContentState extends State<_Content> with TickerProviderStateMixin {
  late AnimationController animCtl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
    debugLabel: 'anim',
  );
  late CurvedAnimation curve =
      CurvedAnimation(parent: animCtl, curve: Curves.linear);

  late Animation<double> anim;
  late int _tick;
  late List<Particle> perticles;
  @override
  void initState() {
    super.initState();

    anim = Tween(end: pi * 8.0, begin: 0.0).animate(curve)
      ..addListener(_update);

    _reset();
  }

  void _update() {
    print("anim.v ${sin(anim.value)}");
    if (anim.isCompleted) {
      print("anim.isCompleted ${anim.value}, ${sin(anim.value)}");
    }
    setState(() {
      perticles = perticles.map((f) => motion1(f)).toList();
      _tick++;
    });
  }

  void _reset() {
    setState(() {
      perticles = [];
      for (var i = 0; i < 20; i++) {
        perticles.add(Particle.random());
      }

      _tick = 0;
    });
    animCtl.forward(from: 0.0);

    // List<Point> d = [Point(4, 0), Point(8, 0)];
    // print(d);
    // d = d.map((f) => Point(f.x * 2, 1)).toList();
    // print(d);
  }

  Particle motion1(Particle pt) {
    var vec = Point(
        pt.vec.x + cos(anim.value) * .01, pt.vec.y + sin(anim.value) * .01);
    return Particle.move(pt.pos, pt.vec, sin(anim.value) * 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text('App Name'),
      ),
      body: Center(
          child: Center(
              child: CustomPaint(
        painter: _MyPainter(perticles),
        willChange: true,
      ))),
      floatingActionButton: FloatingActionButton(
        onPressed: _reset,
        child: const Icon(Icons.replay),
      ),
    );
  }
}

class _MyPainter extends CustomPainter {
  late int tick;
  List<Particle> points;
  _MyPainter(this.points);
  @override
  void paint(Canvas canv, Size size) {
    _draw(canv, Particle.zero(), Colors.black);
    for (var f in points) {
      _draw(canv, f);
    }
  }

  void _draw(Canvas canv, Particle pt, [Color color = Colors.blue]) {
    canv.save();
    canv.translate(pt.pos.x.toDouble(), pt.pos.y.toDouble());
    canv.drawCircle(
      const Offset(0.0, 0.0),
      8.0,
      Paint()
        ..color = color
        ..blendMode = BlendMode.multiply
        ..style = PaintingStyle.fill,
    );
    canv.restore();
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
      : pos = const Point(0.0, 0.0),
        vec = Point(r.nextDouble() * 2.0 - 1.0, r.nextDouble() * 2.0 - 1.0),
        velocity = r.nextDouble() * 2.0 + 4.0;

  Particle.move(this.pos, this.vec, this.velocity) {
    pos = Point(pos.x + (vec.x * velocity), pos.y + (vec.y * velocity));
  }
}
