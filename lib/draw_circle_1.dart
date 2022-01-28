import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'dart:math';

class DrawCircle1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor:  Color(0xFFEEEEEE),
      body: _Content(),
    );
  }
}

class _Content extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ContentState();
}

class _ContentState extends State<_Content> with TickerProviderStateMixin {
  late AnimationController animCtl;
  late Animation<double> anim;
  late CurvedAnimation curve;
  late int _tick;
  late double x;
  late Point p1;
  @override
  void initState() {
    super.initState();

    animCtl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      debugLabel: 'anim',
    );

    curve = CurvedAnimation(parent: animCtl, curve: Curves.easeIn);
    anim = Tween(end: pi, begin: 0.0).animate(curve)..addListener(_update);

    _reset();
  }

  void _update() {
    print(anim.value);
    setState(() {
      p1 = Point(sin(anim.value * 4) * 100.0, cos(anim.value * 4) * 100.0);
      _tick++;
    });
  }

  void _reset() {
    setState(() {
      p1 = Point(0, 100.0);
      _tick = 0;
    });
    animCtl.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: Text('App Name'),
      ),
      body: Center(
          child: Center(
              child: Container(
                  child: CustomPaint(
        painter: _MyPainter(p1),
        willChange: true,
      )))),
      floatingActionButton: FloatingActionButton(
        onPressed: _reset,
        child: Icon(Icons.replay),
      ),
    );
  }
}

class _MyPainter extends CustomPainter {
  late int tick;
  Point pt;
  _MyPainter(this.pt);
  @override
  void paint(Canvas canv, Size size) {
    canv.save();
    canv.translate(pt.x.toDouble(), pt.y.toDouble());
    canv.drawCircle(
      Offset(0.0, 0.0),
      30.0,
      Paint()
        ..color = Colors.red
        ..style = PaintingStyle.fill,
    );
    canv.restore();
    canv.drawCircle(
      Offset(0.0, 0.0),
      30.0,
      Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
