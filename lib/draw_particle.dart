import 'dart:ui';
import 'dart:math';
import 'foundation.dart';
import 'package:color/color.dart' show HslColor;

Particle core;
List<Particle> particles;
final rdm = Random();
FoundationWindow foundation;

void main() {
  _reset();
  foundation = FoundationWindow(update);
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
      Point(rdm.nextDouble() * 200.0 + 100.0, rdm.nextDouble() * 200.0 + 100.0);
  core.energy = 1.0;
  core.friction = 1.0;
}

Particle motion1(Particle pt) {
  pt.update(
      Point((core.pos.x - pt.pos.x) * .09, (core.pos.y - pt.pos.y) * .09));
  return pt;
}

void _reset() {
  print('reset');
  particles = [];
  _createCore();
  spawn();
}

void spawn(){
  var l = 36;
  if(particles.length>l)
  {
    particles.removeAt(l-1);
  }
  for (var i = 0; i < l; i++) {
    if(particles.length<=i)
    {
      particles.add(Particle.random());
    }
  }
}

void update(Canvas canv) {
  //FoundationWindow.drawGuid(canv);
  if (foundation.tick % 150 == 0){
    _changeTarget();
    spawn();
  } 

  if (foundation.snapShot != null) {
    canv.drawImage(
        foundation.snapShot, Offset.zero, 
        Paint()
        ..blendMode = BlendMode.darken);
  }

  canv.drawColor(
    Color(0x0F000000),
    BlendMode.darken);

  particles = particles.map((f) => motion1(f)).toList();
  core.moveTarget();
  _drawParticle(canv, core, Color.fromARGB(0xFF, 16, 180, 179));
  particles.forEach((f) => _drawParticle(canv, f, f.color));
}

void _drawParticle(Canvas canv, Particle pt,
    [Color color = const Color(0xFF9999FF)]) {
  canv.drawCircle(
    Offset(pt.pos.x, pt.pos.y),
    pt.radious,
    Paint()
      ..color = color
      ..blendMode = BlendMode.lighten
      ..style = PaintingStyle.fill,
  );
}

class Particle {
  Point pos;
  Point targetPos;
  Point vec0;
  Point vec;
  double friction = 1.0;
  double energy = 1.0;
  double rad = 0.0;
  double radSpeed = 0.06;
  double radious = 3.0;
  Color color;
  Particle(this.pos, this.vec, this.friction);

  Particle.zero()
      : this.pos = const Point(0.0, 0.0),
        this.vec = const Point(0.0, 0.0),
        this.friction = 0.0;

  Particle.random() {
    var rnd = Random();
    rad = rnd.nextDouble() * pi * 2;
    pos =
        Point(rnd.nextDouble() * 30.0 + 40.0, rnd.nextDouble() * 30.0 + 150.0);
    vec0 = Point(rnd.nextDouble() * 2.0 + 2.0, rnd.nextDouble() * 2.0 + 2.0);
    friction = rnd.nextDouble() * 0.6 + 0.4;
    energy = 1.0;
    radSpeed = rnd.nextDouble() * 0.08 + 0.01;
    var hsl = HslColor(70.0 + rnd.nextDouble() * 160.0, 100, 87.6).toRgbColor();
    color = Color.fromARGB(0xFF, hsl.r, hsl.g, hsl.b);
    vec = Point(1.0, 2.0);
    energy = 1.0;
  }

  void update([Point addForce = const Point(0.0, 0.0)]) {
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
