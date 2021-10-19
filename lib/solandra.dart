library solandra;

import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import 'dart:math';

// Imported but not exported (might change?)
import 'util/color.dart';

// Main parts of library, all exported
import 'path.dart';
import 'util/data.dart';
import 'util/convenience.dart';

export 'path.dart';
export 'util/data.dart';
export 'util/convenience.dart';

// Exported, though not used in this file
export 'iteration.dart';

/// The main class for Solandra. Contains some state such as random number seed and some Paints
class Solandra {
  Canvas canvas;
  Size size;
  Paint fillPaint = Paint()
    ..color = const Color.fromARGB(255, 32, 32, 32)
    ..style = PaintingStyle.fill;

  final c = Color.getAlphaFromOpacity(1);

  Paint strokePaint = Paint()
    ..color = const Color.fromARGB(255, 0, 0, 0)
    ..style = PaintingStyle.stroke;

  late Random _rng;

  Solandra(this.canvas, this.size, {int seed = 0}) {
    _rng = Random(seed);
  }

  /// Clip your drawing to the Canvas size
  clipped() {
    canvas.clipRect(size.rect);
  }

  /// Canvas aspect ratio
  double get aspectRatio => size.width / size.height;

  /// Canvas width
  double get width => size.width;

  /// Canvas height
  double get height => size.height;

  /// Center of Canvas
  Point<double> get center => Point(size.width / 2, size.height / 2);

  /// Draw (stroke) a conventional Dart Path with the current strokePaint
  void drawPath(Path path) {
    canvas.drawPath(path, strokePaint);
  }

  /// Fill a conventional Dart Path with the current fillPaint
  void fillPath(Path path) {
    canvas.drawPath(path, fillPaint);
  }

  /// Draw a Solandra SPath (shape/path) with the current strokePaint
  void draw(SPath path) {
    path.draw(canvas, strokePaint);
  }

  /// Fill a Solandra SPath (shape/path) with the current fillPaint
  void fill(SPath path) {
    path.draw(canvas, fillPaint);
  }

  /// Fill the background. Color is hsl(a), h goes from 0 to 360, others from 0 to 100.
  void background(double h, double s, double l, [double a = 100]) {
    Paint paint = Paint()
      ..color = fromHSLA(h, s, l, a)
      ..style = PaintingStyle.fill;
    canvas.drawRect(size.rect, paint);
  }

  /// Set the color for fillPaint. Color is hsl(a), h goes from 0 to 360, others from 0 to 100.
  void setFillColor(double h, double s, double l, [double a = 100]) {
    fillPaint.color = fromHSLA(h, s, l, a);
  }

  /// Set the color for strokePaint. Color is hsl(a), h goes from 0 to 360, others from 0 to 100.
  void setStrokeColor(double h, double s, double l, [double a = 1.0]) {
    strokePaint.color = fromHSLA(h, s, l, a);
  }

  // Canvas aware Iteration

  /// Get a drawable Area for painting after adding a margin (proportionate)
  void forFrame({required Function(Area area) callback, double? margin}) {
    if (margin != null) {
      forTiling(n: 1, square: false, callback: callback);
    } else {
      callback(Area(
          const Point(0, 0), size, Point(size.width / 2, size.height / 2), 0));
    }
  }

  /// Helper for tiling a canvas
  void forTiling(
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

  /// Go across canvas in chunks, with optional margin
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

  /// Go down canvas in chunks, with optional margin
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

  /// Iteration over an integer grid
  void forGrid(
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

  /// Defaults to rotating around center of Canvas
  void aroundCircle(
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

  /// Set the RNG seed
  set seed(int newSeed) {
    _rng = Random(newSeed);
  }

  /// Get a random point on the canvas
  Point<double> randomPoint() {
    return Point(
        _rng.nextDouble() * size.width, _rng.nextDouble() * size.height);
  }

  /// Get a random angle
  double randomAngle() {
    return _rng.nextDouble() * pi * 2;
  }

  /// Get a random number
  double random() {
    // Want to be able to use same seed for standard operations (so duplicating out of box stuff)
    return _rng.nextDouble();
  }

  /// Get a random integer
  int randomInt(int max) {
    return _rng.nextInt(max);
  }

  /// Get a random boolean
  bool randomBool() {
    return _rng.nextBool();
  }

  /// Get a random Gaussian value
  double gaussian({double mean = 0, double sd = 1}) {
    final a = _rng.nextDouble();
    final b = _rng.nextDouble();
    final n = sqrt(-2.0 * log(a)) * cos(2.0 * pi * b);
    return mean + n * sd;
  }

  /// Get a random Poisson value
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

  /// Pick an item from a list at random
  T sample<T>(List<T> items) {
    return items[randomInt(items.length)];
  }

  /// Pick many items from a list at random (with replacement)
  List<T> samples<T>(List<T> items, int count) {
    List<T> result = <T>[];
    for (int i = 0; i < count; i++) {
      result.add(sample(items));
    }
    return result;
  }

  /// Do the callback a proportion of times
  void doProportion(double proportion, Function() callback) {
    if (random() < proportion) callback();
  }

  /// Give a bunch of cases, do one with probability in proportion to proportion given.
  ///
  /// NB this is unlikely to be the most efficient way to do this when you iterate over it many times as there is some setup cost
  /// but you should be easily able to rewrite if necessary, calling `random()` directly.
  void proportionately(List<Case> cases) {
    final total = cases
        .map((c) => c.proportion)
        .reduce((value, element) => value + element);
    if (total <= 0) throw Exception("Must be positive total");

    var r = random() * total;

    for (var i = 0; i < cases.length; i++) {
      if (cases[i].proportion > r) {
        cases[i].callback();
        return;
      } else {
        r -= cases[i].proportion;
      }
    }
    //fallback *should never happen!*
    cases[0].callback();
  }

  /// Perturb a point (by uniform amount in 2D)
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
