import 'dart:math';
import 'dart:ui';
import 'util/convenience.dart';

abstract class PathEdge {
  void addToPath(Path path);
  PathEdge transformed(Point<double> Function(Point<double>) transform);
  Point<double> get start;
}

class LineEdge extends PathEdge {
  Point<double> from;
  Point<double> to;

  LineEdge(this.from, this.to);

  @override
  void addToPath(Path path) {
    path.lineTo(to.x, to.y);
  }

  @override
  Point<double> get start => from;

  @override
  PathEdge transformed(Point<double> Function(Point<double>) transform) {
    return LineEdge(transform(from), transform(to));
  }
}

class CubicEdge extends PathEdge {
  Point<double> from;
  Point<double> to;
  bool positive;
  double curveSize;
  double curveAngle;
  double bulbousness;
  double twist;

  CubicEdge({
    required this.from,
    required this.to,
    required this.positive,
    required this.curveSize,
    required this.curveAngle,
    required this.bulbousness,
    required this.twist,
  })

  @override
  void addToPath(Path path) {
    double polarity = positive ? 1 : -1;
    final u = to - from;
    final d = u.magnitude;
    final m = from + u * 0.5;
    final perp = (u.rotate(-pi / 2)).normalised;
    final rotatedPerp = perp.rotate(curveAngle);
    final controlMid = m + rotatedPerp * curveSize * polarity * d * 0.5;
    final perpOfRot = rotatedPerp.rotate(-pi / 2 - twist).normalised;
    final control1 = controlMid + perpOfRot * ((bulbousness * d) / 2);
    final control2 = controlMid + perpOfRot * (-(bulbousness * d) / 2);

    path.cubicTo(control1.x, control1.y, control2.x, control2.y, to.x, to.y);
  }

  @override
  Point<double> get start => from;

  @override
  PathEdge transformed(Point<double> Function(Point<double>) transform) {
    return CubicEdge(
      from: transform(from),
      to: transform(to),
      positive: positive,
      curveAngle: curveAngle,
      curveSize: curveSize,
      bulbousness: bulbousness,
      twist: twist
    );
  }
}

/// A higher level Path class; allows both building and manipulation of paths, prior to drawing
class SPath {
  List<PathEdge> edges = List.empty();
  late Point<double> currentPoint;

  SPath(Point<double> start) {
    currentPoint = start;
  }

  line({required Point<double> to}) {
    edges.add(LineEdge(currentPoint, to));
    currentPoint = to;
  }

  curve({
    required Point<double> to,
    bool positive = true,
    double curveSize = 1,
    double curveAngle = 0,
    double bulbousness = 1,
    double twist = 0,
  }) {
    edges.add(CubicEdge(
        from: currentPoint,
        to: to,
        bulbousness: bulbousness,
        curveAngle: curveAngle,
        curveSize: curveSize,
        twist: twist,
        positive: positive));
    currentPoint = to;
  }

  Path get path {
    final path = Path();
    final start = edges[0].start;
    path.moveTo(start.x, start.y);
    for (var edge in edges) {
      edge.addToPath(path);
    }
    return path;
  }

  SPath transformed(Point<double> Function(Point<double>) transform) {
    // hmm, this will work, but kind of don't like how exposing some implementation details
    final newPath = SPath(transform(currentPoint));
    newPath.edges = edges.map((el) => el.transformed(transform)).toList();
    return newPath;
  }

  Point<double> get centroid => edges.map((e) => e.start).centroid;

  SPath moved(Point<double> by) {
    return transformed((p) => p + by);
  }

  SPath scaled(double scale) {
    final c = centroid;
    return transformed((pt) => c + (pt - c) * scale);
  }

  SPath rotated(double angle) {
    final c = centroid;
    return transformed((pt) => c + (pt - c).rotate(angle));
  }

  // TODO fill out more from https://github.com/jamesporter/solandra/blob/master/src/lib/paths/Path.ts plus maybe some new things?
}
