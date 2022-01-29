import 'dart:ui';
import 'dart:math';
import 'foundation.dart';
import 'package:color/color.dart' show HslColor;

late Particle core;
late List<Particle> particles;
final rdm = Random();
late FoundationWindow foundation;

void main() {
  _reset();
  foundation = FoundationWindow(draw);
}

void _changeTarget() {
  core.targetPos = Point(
    rdm.nextDouble() * 120.0 + 200.0,
    rdm.nextDouble() * 300.0 + 200.0,
  );
  core.energy = 0.0;
  core.friction = 1.0;
  core.rad = 0.0;
}

void _createCore() {
  core = Particle(
      Point(
        rdm.nextDouble() * 200.0 + 200.0,
        rdm.nextDouble() * 300.0 + 200.0,
      ),
      Point(rdm.nextDouble() * 2.0 - 1.0, rdm.nextDouble() * 2.0 - 1.0),
      1.0);
  core.targetPos =
      Point(rdm.nextDouble() * 2.0 - 1.0, rdm.nextDouble() * 2.0 - 1.0);
  core.energy = 1.0;
  core.friction = 1.0;
}

Particle motion1(Particle pt) {
  pt.update(
      Point((core.pos.x - pt.pos.x) * .09, (core.pos.y - pt.pos.y) * .09));
  return pt;

  // var dist = pt.pos.distanceTo(core.pos);
  // dist *= dist;
  // dist = min(10.0, dist);
  // var pullF = Point((core.pos.x - pt.pos.x) * 10.0 / dist,
  //     (core.pos.y - pt.pos.y) * 10.0 / dist);

  // if (dist < 10) {
  //   pullF =
  //       Point((core.pos.x - pt.pos.x) * 20.0, (core.pos.y - pt.pos.y) * 20.0);
  //   print(dist);
  // }
  // return pt..update(pullF);
}

void _reset() {
  print('reset');
  particles = [];
  _createCore();
  for (var i = 0; i < 1; i++) {
    particles.add(Particle.random());
  }
}

void spawn() {
  var l = 36;
  if (particles.length > l) {
    particles.removeAt(l - 1);
  }
  for (var i = 0; i < l; i++) {
    if (particles.length <= i) {
      particles.add(Particle.random());
    }
  }
}

void draw(Canvas canv) {
  if (foundation.tick % 150 == 0) {
    _changeTarget();
    spawn();
  }

  if (foundation.snapShot != null) {
    canv.drawImage(foundation.snapShot!, Offset.zero,
        Paint()..blendMode = BlendMode.darken);
  }

  canv.drawColor(Color(0x0F000000), BlendMode.darken);

  particles = particles.map((f) => motion1(f)).toList();
  core.moveTarget();
  _drawParticle(canv, core, const Color.fromARGB(0xFF, 16, 180, 179));
  particles.forEach((f) => _drawParticle(canv, f, f.color));
}

void _drawParticle(Canvas canv, Particle pt,
    [Color color = const Color(0xFF9999FF)]) {
  canv.drawCircle(
    Offset(pt.pos.x.toDouble(), pt.pos.y.toDouble()),
    pt.radious,
    Paint()
      ..color = color
      ..blendMode = BlendMode.lighten
      ..style = PaintingStyle.fill,
  );
}

void _drawGuid(Canvas canv) {
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

class Particle {
  late Point pos;
  late Point vec;
  late double friction = 1.0;
  late Point targetPos;
  late Point vec0;
  late double energy = 1.0;
  late double rad = 0.0;
  late double radSpeed = 0.06;
  late double radious = 3.0;
  late Color color;

  static final rnd = Random();

  Particle(this.pos, this.vec, this.friction);

  Particle.zero()
      : pos = const Point(0.0, 0.0),
        vec = const Point(0.0, 0.0),
        friction = 0.0;

  Particle.random() {
    rad = rnd.nextDouble() * pi * 2;
    pos =
        Point(rnd.nextDouble() * 30.0 + 40.0, rnd.nextDouble() * 30.0 + 150.0);
    vec0 = Point(rnd.nextDouble() * 2.0 + 2.0, rnd.nextDouble() * 2.0 + 2.0);
    friction = rnd.nextDouble() * 0.6 + 0.4;
    energy = 1.0;
    radSpeed = rnd.nextDouble() * 0.08 + 0.01;
    var hsl = HslColor(70.0 + rnd.nextDouble() * 160.0, 100, 87.6).toRgbColor();
    color = Color.fromARGB(0xFF, hsl.r.toInt(), hsl.g.toInt(), hsl.b.toInt());
    // pos = Point(40.0, 160.0);
    // vec0 = Point(3.0, 3.0);
    vec = const Point(1.0, 2.0);
    // friction = 1.0;
    energy = 1.0;

    // perticles.add(Particle(Point(100.0, 0.0), Point(0, 10.0), 0.1));
  }
  void updatePos(double x, double y) {
    pos =
        Point(pos.x + (x * energy) * friction, pos.y + (y * energy) * friction);
  }

  void update([Point addForce = const Point(0.0, 0.0)]) {
    // energy *= 0.999;
    rad += radSpeed;
    vec = Point(sin(rad) * vec0.x, cos(rad) * vec0.y);
    pos = Point(pos.x + (addForce.x + vec.x * energy) * friction,
        pos.y + (addForce.y + vec.y * energy) * friction);
  }

  void moveTarget() {
    var x = pos.x + (targetPos.x - pos.x) / 4.0 * energy * friction;
    var y = pos.y + (targetPos.y - pos.y) / 4.0 * energy * friction;
    var p = sin(rad);
    energy = 1.0 * p;
    // var x = pos.x + vec.x * p * energy * friction;
    // var y = pos.y + vec.y * p * energy * friction;
    rad += 0.003;

    pos = Point(x, y);
  }

  Particle.move(this.pos, this.vec, this.friction) {
    pos = Point(pos.x + (vec.x * friction), pos.y + (vec.y * friction));
  }

  Particle move() {
    return Particle(
        Point(pos.x + (vec.x * friction), pos.y + (vec.y * friction)),
        this.vec,
        this.friction);
  }
}
