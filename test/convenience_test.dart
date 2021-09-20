import 'dart:math';
import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:solandra/solandra.dart';

void main() {
  test('convenience functionality for Size', () {
    const s = Size(24, 24);
    const s2 = Size(10, 24);
    const s3 = Size(2, 102);

    final r = s.rect;
    expect(r.width, s.width);
    expect(r.height, s.height);

    expect(s.magnitude, closeTo(33.9411, 0.01));
    expect(s2.magnitude, closeTo(26, 0.01));
    expect(s3.magnitude, closeTo(102.0196, 0.01));

    expect(s.minimum, 24);
    expect(s2.minimum, 10);
    expect(s3.minimum, 2);

    final p = s.point;
    expect(p.x, s.width);
    expect(p.y, s.height);
  });

  test('convenience functionality for Point', () {
    const p = Point<double>(4, 3);
    const p2 = Point<double>(5, 8);
    final pR = p.rotate(pi / 2);

    expect(pR.x, closeTo(-3, 000.1));
    expect(pR.y, closeTo(4, 000.1));

    final pN = p.normalised;
    expect(pN.x, closeTo(0.8, 0.01));
    expect(pN.y, closeTo(0.6, 0.01));

    final pT = const Point(0.0, 0.0).pointTowards(p, proportion: 0.25);
    expect(pT.x, closeTo(1.0, 0.01));
    expect(pT.y, closeTo(0.75, 0.01));

    final dp = p.dot(p2);
    expect(dp, closeTo(44.0, 0.01));

    final offP = p.offset;
    expect(offP.dx, closeTo(4.0, 0.01));
    expect(offP.dy, closeTo(3.0, 0.01));
  });

  test('convenience functionality for Iterable<Point<double>>', () {
    final items = [Point(2.0, 2.0), Point(4.0, 1.0), Point(-0.3, -0.4)];
    final c = items.centroid;
    expect(c.x, closeTo(1.9, 0.01));
    expect(c.y, closeTo(0.86667, 0.01));
  });
}
