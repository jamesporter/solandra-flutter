library solandra;

import 'package:flutter/widgets.dart';
import 'package:solandra/drawables.dart';
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

  late Random _rng;

  Solandra(this.canvas, this.size, {int seed = 0}) {
    _rng = Random(seed);
  }

  clipped() {
    canvas.clipRect(size.rect);
  }

  double get aspectRatio => size.width / size.height;
  double get width => size.width;
  double get height => size.height;
  Point<double> get center => Point(size.width / 2, size.height / 2);

  draw(Path path) {
    canvas.drawPath(path, strokePaint);
  }

  fill(Path path) {
    canvas.drawPath(path, fillPaint);
  }

  // don't like naming... in Dart can't repeat, this would be used commonly to want to be concise
  // could extend Path to be drawable to only have a pair of methods, but would people need to import?
  drawD(Drawable drawable) {
    drawable.draw(canvas, strokePaint);
  }

  fillD(Drawable drawable) {
    drawable.draw(canvas, fillPaint);
  }

  background(double h, double s, double l, [double a = 100]) {
    Paint paint = Paint()
      ..color = fromHSLA(h, s, l, a)
      ..style = PaintingStyle.fill;
    canvas.drawRect(size.rect, paint);
  }

  setFillColor(double h, double s, double l, [double a = 100]) {
    fillPaint.color = fromHSLA(h, s, l, a);
  }

  setStrokeColor(double h, double s, double l, [double a = 1.0]) {
    strokePaint.color = fromHSLA(h, s, l, a);
  }

  // Canvas aware Iteration

  forFrame({required Function(Area area) callback, double? margin}) {
    if (margin != null) {
      forTiling(n: 1, square: false, callback: callback);
    } else {
      callback(Area(
          const Point(0, 0), size, Point(size.width / 2, size.height / 2), 0));
    }
  }

  forTiling(
      {required int n,
      bool square = true,
      double margin = 0,
      bool columnFirst = true,
      required Function(Area area) callback}) {
    if (n < 1) throw Exception("Must be positive n");
    var k = 0;

    final marginSize = margin * size.width;
    final nY = square ? (n * (1 / aspectRatio)).floor() : n;
    final deltaX = (size.width - marginSize * 2) / n;
    final hY = square ? deltaX * nY : size.height - 2 * marginSize;
    final deltaY = hY / nY;
    final sX = marginSize;
    final sY = (size.height - hY) / 2;

    if (columnFirst) {
      for (var i = 0; i < n; i++) {
        for (var j = 0; j < nY; j++) {
          callback(Area(
              Point(sX + i * deltaX, sY + j * deltaY),
              Size(deltaX, deltaY),
              Point(sX + i * deltaX + deltaX / 2, sY + j * deltaY + deltaY / 2),
              k));
          k++;
        }
      }
    } else {
      for (var j = 0; j < nY; j++) {
        for (var i = 0; i < n; i++) {
          callback(Area(
              Point(sX + i * deltaX, sY + j * deltaY),
              Size(deltaX, deltaY),
              Point(sX + i * deltaX + deltaX / 2, sY + j * deltaY + deltaY / 2),
              k));
          k++;
        }
      }
    }
  }

  void forHorizontal(
      {required int n,
      double margin = 0.0,
      required Function(Area area) callback}) {
    final sX = margin * width;
    final eX = (1 - margin) * width;
    final sY = sX;
    final dY = height - 2 * sY;
    final dX = (eX - sX) / n;

    for (var i = 0; i < n; i++) {
      callback(Area(Point(sX + i * dX, sY), Size(dX, dY),
          Point(sX + i * dX + dX / 2, sY + dY / 2), i));
    }
  }

  void forVertical(
      {required int n,
      double margin = 0.0,
      required Function(Area area) callback}) {
    final sX = margin * width;
    final eY = (1 - margin) * width;
    final sY = sX;
    final dX = width - 2 * sX;
    final dY = (eY - sY) / n;

    for (var i = 0; i < n; i++) {
      callback(Area(Point(sX, sY + i * dY), Size(dX, dY),
          Point(sX + dX / 2, sY + i * dY + dY / 2), i));
    }
  }

  forGrid(
      {int minX = 0,
      required int maxX,
      int minY = 0,
      required int maxY,
      bool columnFirst = true,
      required Function(Point<int> point, int index) callback}) {
    var k = 0;
    if (columnFirst) {
      for (var i = minX; i <= maxX; i++) {
        for (var j = minY; j <= maxY; j++) {
          callback(Point(i, j), k);
          k++;
        }
      }
    } else {
      for (var j = minY; j <= maxY; j++) {
        for (var i = minX; i <= maxX; i++) {
          callback(Point(i, j), k);
          k++;
        }
      }
    }
  }

  aroundCircle(
      {Point<double>? at,
      required double radius,
      required int n,
      required Function(Point<double>, int) callback}) {
    final dA = (pi * 2) / n;
    var a = -pi * 0.5;
    Point<double> c = at ?? center;
    for (var i = 0; i < n; i++) {
      callback(
          Point(c.x + radius * cos(a + dA), c.y + radius * sin(a + dA)), i);
      a += dA;
    }
  }

  // RNG

  set seed(int newSeed) {
    _rng = Random(newSeed);
  }

  Point<double> randomPoint() {
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

  doProportion(double proportion, Function() callback) {
    if (random() < proportion) callback();
  }

  /// Give a bunch of cases, do one with probabilty in proportion to proportion given.
  ///
  /// NB this is unlikely to be the most efficient way to do this when you iterate over it many times
  proportionately(List<Case> cases) {
    final total = cases
        .map((c) => c.proportion)
        .reduce((value, element) => value + element);
    if (total <= 0) throw Exception("Must be positive total");

    var r = random() * total;

    for (var i = 0; i < cases.length; i++) {
      if (cases[i].proportion > r) {
        return cases[i].callback();
      } else {
        r -= cases[i].proportion;
      }
    }
    //fallback *should never happen!*
    return cases[0].callback();
  }

  Point<double> perturb(
      {required Point<double> at, required double magnitude}) {
    return Point(
      at.x + magnitude * (random() - 0.5),
      at.y + magnitude * (random() - 0.5),
    );
  }

  /// Shuffle a List, importantly uses same RNG as other random code.
  List<T> shuffle<T>(List<T> items) {
    var currentIndex = items.length;
    late T temporaryValue;
    var randomIndex = 0;

    while (0 != currentIndex) {
      randomIndex = (random() * currentIndex).floor();
      currentIndex -= 1;

      // And swap it with the current element.
      temporaryValue = items[currentIndex];
      items[currentIndex] = items[randomIndex];
      items[randomIndex] = temporaryValue;
    }
    return items;
  }
}
