import 'dart:math';
import 'dart:ui';
import 'foundation.dart';
import 'package:flutter/material.dart';

FoundationWindow foundation;
num rad = 0.0;
const rectW = 50.0;

void main() {
  foundation = FoundationWindow(update);
}

void update(Canvas canvas) {
  
  canvas.drawRect(
      Rect.fromLTWH(0.0, 0.0, 200.0, 200.0), Paint()..color = Colors.red);

  canvas.saveLayer(Offset(10.0, 10.0) & Size(90.0, 90.0),
      new Paint()..blendMode = BlendMode.lighten);
  canvas.drawRect(
      Rect.fromLTWH(0.0, 0.0, 100.0, 100.0), Paint()..color = Colors.blue);
  canvas.restore();

  canvas.saveLayer(Offset(50.0, 50.0) & Size(100.0, 100.0),
      new Paint()..blendMode = BlendMode.difference);
  canvas.drawRect(
      Rect.fromLTWH(50.0, 50.0, 100.0, 100.0), Paint()..color = Colors.green);
  canvas.restore();
}
