import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:solandra/iteration.dart';
import 'package:solandra/solandra.dart';
import 'package:collection/collection.dart';

// NB changes here won't get live reloaded
List<Function(Canvas, Size)> painters = [
  (canvas, size) {
    final sol = Solandra(canvas, size);
    sol.clipped();
    sol.background(100, 1, 90);
    times(32, (_) {
      sol.setFillColor(sol.sample([190, 210, 220]), 80, 50, 50);
      canvas.drawCircle(
          sol.randomPoint().offset,
          sol.gaussian(sd: size.width / 12, mean: size.width / 8),
          sol.fillPaint);
    });
  },
  (canvas, size) {
    final sol = Solandra(canvas, size);
    sol.clipped();
    sol.background(100, 1, 10);

    SPath.regularPolygon(radius: size.minimum * 0.4, at: sol.center, n: 20)
        .segmented
        .expand((p) => p.exploded(scale: 0.75, magnitude: 1.1))
        .expand((p) => p.exploded(scale: 0.75, magnitude: 1.3))
        .forEachIndexed((i, p) {
      sol.setFillColor(i * 5, 80, 70);
      sol.fill(p);
    });
  },
  (canvas, size) {
    final sol = Solandra(canvas, size);
    sol.clipped();
    sol.background(200, 5, 90);
    times(5, (i) {
      sol.setStrokeColor(190 + i * 10, 80, 50, 60);
      sol.strokePaint.strokeWidth = size.minimum / 120;
      sol.strokePaint.strokeCap = StrokeCap.round;

      final List<Point<double>> points = [];
      final R = size.minimum * 0.25;
      var r = R;
      final center = sol.center;

      for (var i = 0; i <= 64; i++) {
        r = R + sol.gaussian(sd: R / 3);
        points.add(Point(
            center.x + r * cos(pi * i / 8), center.y + r * sin(pi * i / 8)));
      }
      sol.draw(SPath.fromPoints(points).chaikin(n: 4));
    });
  },
  (canvas, size) {
    final sol = Solandra(canvas, size);
    sol.clipped();
    sol.background(200, 5, 90);
    List<Point<double>> centres = [];
    sol.forTiling(
        n: 10,
        square: true,
        margin: 0.1,
        callback: (area) {
          centres.add(area.center);
        });
    centres = sol.shuffle(centres);
    for (final c in centres) {
      final m = (c.x + c.y) / (size.width + size.height);
      sol.setStrokeColor(210, 10, 10, 90);
      sol.setFillColor(140 + 50 * m, 80, 70, 80);
      sol.strokePaint.strokeWidth = 8;

      canvas.drawCircle(c.offset, m * size.magnitude / 20, sol.fillPaint);
      canvas.drawCircle(c.offset, m * size.magnitude / 20, sol.strokePaint);
    }
  }
];

class ExampleOnePainter extends CustomPainter {
  int idx;
  ExampleOnePainter(this.idx);

  @override
  void paint(Canvas canvas, Size size) {
    painters[idx](canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ExampleOne extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final idx = useState(0);
    return Scaffold(
      appBar: AppBar(title: const Text("Slideshow")),
      body: CustomPaint(
          painter: ExampleOnePainter(idx.value), child: Container()),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            int newIdx = idx.value + 1;
            if (newIdx >= painters.length) {
              newIdx = 0;
            }
            idx.value = newIdx;
          },
          child: const Icon(Icons.forward)),
    );
  }
}
