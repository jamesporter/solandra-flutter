library solandra;

import 'package:flutter/widgets.dart';
import 'package:solandra/path.dart';
import 'package:solandra/util/data.dart';
import 'util/color.dart';
import 'package:flutter/painting.dart';
import 'dart:math';
import 'util/convenience.dart';

class Solandra {
  Canvas canvas;
  Size size;
  Paint fillPaint = Paint()
    ..color = const Color.fromARGB(255, 32, 32, 32)
    ..style = PaintingStyle.fill;

  Paint strokePaint = Paint()
    ..color = const Color.fromARGB(255, 0, 0, 0)
    ..style = PaintingStyle.stroke;

  Random _rng = Random(0);

  Solandra(this.canvas, this.size);

  draw(Path path) {
    canvas.drawPath(path, strokePaint);
  }

  fill(Path path) {
    canvas.drawPath(path, fillPaint);
  }

  // hmmm, want to let people save typing with SPath, but this doesn't feel ideal
  drawS(SPath path) {
    draw(path.path);
  }

  fillS(SPath path) {
    fill(path.path);
  }

  background(double h, double s, double v, {double a = 100}) {
    Paint paint = Paint()
      ..color = fromHSVA(h, s, v, a)
      ..style = PaintingStyle.fill;
    canvas.drawRect(size.rect, paint);
  }

  setFillColor(double h, double s, double v, {double a = 100}) {
    fillPaint.color = fromHSVA(h, s, v, a);
  }

  setStrokeColor(double h, double s, double v, {double a = 1.0}) {
    strokePaint.color = fromHSVA(h, s, v, a);
  }

  withFrame(Function(Area area) callback, {double? margin}) {
    if (margin != null) {
      // TODO! (use the eventual tiling stuff for this)
    } else {
      callback(Area(
          const Point(0, 0), size, Point(size.width / 2, size.height / 2), 0));
    }
  }

  set seed(int newSeed) {
    _rng = Random(newSeed);
  }

  Point randomPoint() {
    return Point(
        _rng.nextDouble() * size.width, _rng.nextDouble() * size.height);
  }

  double randomAngle() {
    return _rng.nextDouble() * pi * 2;
  }

  // Want to be able to use same seed for standard operations (so duplicating out of box stuff)
  double random() {
    return _rng.nextDouble();
  }

  int randomInt(int max) {
    return _rng.nextInt(max);
  }

  bool randomBool() {
    return _rng.nextBool();
  }

  double gaussian({double mean = 0, double sd = 1}) {
    final a = _rng.nextDouble();
    final b = _rng.nextDouble();
    final n = sqrt(-2.0 * log(a)) * cos(2.0 * pi * b);
    return mean + n * sd;
  }

  int poisson(int lambda) {
    final limit = exp(-lambda);
    double prod = _rng.nextDouble();
    int n = 0;
    while (prod >= limit) {
      n++;
      prod *= _rng.nextDouble();
    }
    return n;
  }

  T sample<T>(List<T> items) {
    return items[randomInt(items.length)];
  }

  List<T> samples<T>(List<T> items, int count) {
    List<T> result = <T>[];
    for (int i = 0; i < count; i++) {
      result.add(sample(items));
    }
    return result;
  }
}
