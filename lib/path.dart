import 'dart:math';
import 'dart:ui';
import 'util/convenience.dart';

/// Have lines or bezier curves, hence this parent class
abstract class PathEdge {
  /// Add to a (standard) Path; for drawing
  void addToPath(Path path);

  /// Transform an edge with a function (on Point<double>)
  PathEdge transformed(Point<double> Function(Point<double>) transform);

  /// Start of edge
  Point<double> get start;

  /// End of edge
  Point<double> get end;

  /// Make a copy, want to ensure immutability in some places
  PathEdge copy();
}

/// A line part of a path
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
  Point<double> get end => to;

  @override
  PathEdge transformed(Point<double> Function(Point<double>) transform) {
    return LineEdge(transform(from), transform(to));
  }

  @override
  PathEdge copy() => LineEdge(from, to);
}

/// Cubic bezier curve in path. Note that offers a novel API that is more human friendly: describe curve features in way that is invariant to size, rather than the standard control points (which are implicitly related to start and end points).
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
  });

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
  Point<double> get end => to;

  @override
  PathEdge transformed(Point<double> Function(Point<double>) transform) {
    return CubicEdge(
        from: transform(from),
        to: transform(to),
        positive: positive,
        curveAngle: curveAngle,
        curveSize: curveSize,
        bulbousness: bulbousness,
        twist: twist);
  }

  @override
  PathEdge copy() {
    return CubicEdge(
      from: from,
      to: to,
      positive: positive,
      curveSize: curveSize,
      curveAngle: curveAngle,
      bulbousness: bulbousness,
      twist: twist,
    );
  }
}

/// A higher level Path class; allows both building and manipulation of paths, prior to drawing
class SPath {
  List<PathEdge> edges = <PathEdge>[];
  late Point<double> currentPoint;

  SPath(Point<double> start) {
    currentPoint = start;
  }

  /// Conveniently construct from a List of Point<double>
  SPath.fromPoints(List<Point<double>> points) {
    if (points.isEmpty) throw Exception("Must supply at least one point");
    currentPoint = points.first;
    for (var i = 1; i < points.length; i++) {
      line(to: points[i]);
    }
  }

  /// Add a line to a point
  void line({required Point<double> to}) {
    edges.add(LineEdge(currentPoint, to));
    currentPoint = to;
  }

  /// Add a curve to a point
  void curve({
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

  /// Close a shape (add a line to the start)
  void close() {
    if (edges.isEmpty) throw Exception("Must have at least one point to close");
    line(to: edges[0].start);
  }

  /// Get as a Path (for drawing in Flutter etc)
  Path get path {
    final path = Path();
    final start = edges[0].start;
    path.moveTo(start.x, start.y);
    for (var edge in edges) {
      edge.addToPath(path);
    }
    return path;
  }

  /// Transform via transform on Point<double>
  SPath transformed(Point<double> Function(Point<double>) transform) {
    // hmm, this will work, but kind of don't like how exposing some implementation details
    final newPath = SPath(transform(currentPoint));
    newPath.edges = edges.map((el) => el.transformed(transform)).toList();
    return newPath;
  }

  /// List of points. Loses details on curves
  List<Point<double>> get points => edges.map((e) => e.start).toList();

  /// Centroid (average) point. Is often a good enough approximation for true centroid of a shape
  Point<double> get centroid => edges.map((e) => e.start).centroid;

  /// Move the shape
  SPath moved(Point<double> by) {
    return transformed((p) => p + by);
  }

  /// Scale the shape about its approximate centroid
  SPath scaled(double scale, {Point<double>? about}) {
    final c = about ?? centroid;
    return transformed((pt) => c + (pt - c) * scale);
  }

  /// Rotate the shape about its approximate centroid
  SPath rotated(double angle) {
    final c = centroid;
    return transformed((pt) => c + (pt - c).rotate(angle));
  }

  /// Draw the shape
  void draw(Canvas canvas, Paint paint) {
    canvas.drawPath(path, paint);
  }

  /// Thinking looking down on orange segments
  List<SPath> get segmented {
    if (edges.length < 2) {
      throw Exception("You must have at least two edges to segment a (S)Path");
    }
    final c = centroid;
    final n = edges.length;
    List<SPath> paths = [];
    for (var i = 0; i < n; i++) {
      final p = SPath(edges[i].start);
      p.edges.add(edges[i].copy());
      p.currentPoint = edges[i].end;
      p.line(to: c);
      p.close();
      paths.add(p);
    }
    return paths;
  }

  /// Segment then explode outwards and scale
  List<SPath> exploded({double magnitude = 1.2, double scale = 1}) {
    if (edges.length < 2) {
      throw Exception("You must have at least two edges to segment a (S)Path");
    }
    final c = centroid;
    final n = edges.length;
    List<SPath> paths = [];
    for (var i = 0; i < n; i++) {
      var p = SPath(edges[i].start);
      p.edges.add(edges[i].copy());
      p.currentPoint = edges[i].end;
      p.line(to: c);
      p.close();
      p = p.scaled(scale);
      // local centroid minus global is relative direction; multiply by magnitude - 1 to get the displacement to apply
      p = p.moved((p.centroid - centroid) * (magnitude - 1.0));
      paths.add(p);
    }
    return paths;
  }

  /// A way to smooth out a path of lines; after just a few applications it will look like a nice curve.
  /// NB this converts the SPath to lines i.e. detail in any existing curves will be lost
  /// If the path forms a look you probably want to opt in to the looped option.
  SPath chaikin({int n = 1, bool looped = false}) {
    var pts = points;
    if (pts.length < 3) {
      throw Exception("Must have at least 3 points to perform this");
    }
    List<Point<double>> newPts = [];
    for (var i = 0; i < n; i++) {
      if (!looped) {
        newPts.add(pts[0]);
      }
      final m = pts.length - 2;
      for (var j = 0; j < m; j++) {
        final a = pts[j];
        final b = pts[j + 1];
        final c = pts[j + 2];

        newPts.add(b.pointTowards(a, proportion: 0.25));
        newPts.add(b.pointTowards(c, proportion: 0.25));
      }

      if (!looped) {
        newPts.add(pts.last);
      }

      pts = newPts;
      newPts = [];
    }
    // In the JS version I did some extra slice thing at end... this was very fiddly, not doing yet
    return SPath.fromPoints(pts);
  }

  // Shapes

  /// A star shape
  SPath.star(
      {double? innerRadius,
      required double radius,
      required Point<double> at,
      int n = 5,
      double startAngle = 0}) {
    var a = -pi / 2 + startAngle;
    final iR = innerRadius ?? radius / 2;
    final dA = (pi * 2) / n;
    currentPoint = Point(at.x + radius * cos(a), at.y + radius * sin(a));
    for (var i = 1; i < n; i++) {
      line(
          to: Point(at.x + iR * cos(a + (i - 0.5) * dA),
              at.y + iR * sin(a + (i - 0.5) * dA)));
      line(
          to: Point(at.x + radius * cos(a + i * dA),
              at.y + radius * sin(a + i * dA)));
    }
    line(
        to: Point(
            at.x + iR * cos(a - 0.5 * dA), at.y + iR * sin(a - 0.5 * dA)));
    close();
  }

  /// A regular polygon shape
  SPath.regularPolygon(
      {required double radius,
      required Point<double> at,
      int n = 5,
      double startAngle = 0}) {
    var a = -pi / 2 + startAngle;
    final dA = (pi * 2) / n;
    currentPoint = Point(at.x + radius * cos(a), at.y + radius * sin(a));
    for (var i = 1; i < n; i++) {
      line(
          to: Point(at.x + radius * cos(a + i * dA),
              at.y + radius * sin(a + i * dA)));
    }
    close();
  }

  /// A spiral shape made up of lines
  SPath.spiral(
      {required Point<double> at,
      required int n,
      required double l,
      startAngle = 0,
      double rate = 20}) {
    var a = startAngle;
    var r = l;

    currentPoint = at + Point(r * cos(a), r * sin(a));
    for (var i = 0; i < n; i++) {
      final dA = 2 * asin(l / (r * 2));
      r += rate * dA;
      a += dA;
      line(to: at + Point(r * cos(a), r * sin(a)));
    }
  }

  /// A rectangle shape
  SPath.rect(
      {required Point<double> at, required Size size, bool centered = false}) {
    if (centered) {
      final dX = size.width / 2;
      final dY = size.height / 2;
      currentPoint = at + Point(-dX, -dY);
      line(to: at + Point(dX, -dY));
      line(to: at + Point(dX, dY));
      line(to: at + Point(-dX, dY));
      close();
    } else {
      currentPoint = at;
      line(to: at + Point(size.width, 0));
      line(to: at + Point(size.width, size.height));
      line(to: at + Point(0, size.height));
      close();
    }
  }
}
