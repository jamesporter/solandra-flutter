import 'dart:math';
import 'dart:ui';

extension SizeHelpers on Size {
  Rect get rect => const Offset(0, 0) & this;
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
