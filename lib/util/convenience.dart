import 'dart:math';
import 'dart:ui';

extension SizeHelpers on Size {
  Rect get rect => const Offset(0, 0) & this;
  double get magnitude => sqrt(width * width + height * height);
  double get minimum => min(width, height);
}

extension PointHelpers<T extends num> on Point<T> {
  Point<double> rotate(T angle) =>
      Point(x * cos(angle) - y * sin(angle), x * sin(angle) + y * cos(angle));

  Point<double> get normalised {
    final m = magnitude;
    return Point(x / m, y / m);
  }
}

extension PointHelpersD on Point<double> {
  Point<double> pointTowards(Point<double> otherPoint,
      {double proportion = 0.5}) {
    return this + (otherPoint - this) * proportion;
  }

  double dot(Point<double> other) => x * other.x + y * other.y;
}

extension CentroidCalc on Iterable<Point<double>> {
  Point<double> get centroid {
    Point<double> p = Point<double>(0, 0);
    for (final el in this) {
      p += el;
    }
    int n = length;
    if (n == 0) n = 1;
    return Point(p.x / n, p.y / n);
  }
}
