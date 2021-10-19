import 'dart:math';
import 'dart:ui';

/// Helpers for Size (especially conversions)
extension SizeHelpers on Size {
  /// Convert to Rect (at 0,0)
  Rect get rect => const Offset(0, 0) & this;

  /// Get the magnitude of a Size
  double get magnitude => sqrt(width * width + height * height);

  /// Get minimum dimension
  double get minimum => min(width, height);

  /// Convert to a point
  Point<double> get point => Point(width, height);
}

/// Helpers for Point<double>, mostly mathematical things
extension PointHelpers on Point<double> {
  /// Rotate (about 0,0)
  Point<double> rotate(double angle) =>
      Point(x * cos(angle) - y * sin(angle), x * sin(angle) + y * cos(angle));

  /// Normalised version of point
  Point<double> get normalised {
    final m = magnitude;
    return Point(x / m, y / m);
  }

  /// Go towards an other point by a proportion
  Point<double> pointTowards(Point<double> otherPoint,
      {double proportion = 0.5}) {
    return this + (otherPoint - this) * proportion;
  }

  /// Dot product
  double dot(Point<double> other) => x * other.x + y * other.y;

  /// Convert to Offset
  Offset get offset => Offset(x, y);
}

/// Calculation helper for collections of points
extension CentroidCalc on Iterable<Point<double>> {
  /// Get a centroid (average point) for Iterable of Points
  Point<double> get centroid {
    Point<double> p = const Point<double>(0, 0);
    for (final el in this) {
      p += el;
    }
    int n = length;
    if (n == 0) n = 1;
    return Point(p.x / n, p.y / n);
  }
}
