import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';

class DrawAnimation extends StatelessWidget {
  const DrawAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color(0xFFEEEEEE), body: _Content());
  }
}

class _Content extends StatefulWidget {
  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<_Content> with TickerProviderStateMixin {
  double percentage = 0.0;
  double newPercentage = 0.0;
  late final AnimationController percentageAnimationController =
      AnimationController(vsync: this, duration: const Duration(seconds: 5))
        ..addListener(() {
          setState(() {
            log(percentageAnimationController.value);
            percentage = lerpDouble(percentage, newPercentage,
                percentageAnimationController.value)!;
          });
        });

  @override
  void initState() {
    super.initState();
    setState(() => percentage = 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 200.0,
        width: 200.0,
        child: CustomPaint(
          foregroundPainter:
              MyPainter(Colors.amber, Colors.blueAccent, percentage, 8.0),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple,
                  onPrimary: Colors.blueAccent,
                  shape: const CircleBorder(),
                ),
                child: const Text("Click"),
                onPressed: () {
                  setState(() {
                    percentage = newPercentage;
                    newPercentage += 10;
                    if (newPercentage > 100.0) {
                      percentage = 0.0;
                      newPercentage = 0.0;
                    }
                    percentageAnimationController.forward(from: 0.0);
                  });
                }),
          ),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final Color lineColor;
  final Color completeColor;
  final double completePercent;
  final double width;
  MyPainter(
      this.lineColor, this.completeColor, this.completePercent, this.width);
  @override
  void paint(Canvas canvas, Size size) {
    Paint line = Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Paint complete = Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    canvas.drawCircle(center, radius, line);
    double arcAngle = 2 * pi * (completePercent / 100);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        arcAngle, false, complete);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
