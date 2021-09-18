import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:solandra/iteration.dart';
import 'package:solandra/path.dart';
import 'package:solandra/solandra.dart';

class ExampleSixPainter extends CustomPainter {
  ExampleSixPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final sol = Solandra(canvas, size);
    sol.clipped();
    sol.background(45, 30, 95);

    sol.forTiling(
        n: 5,
        margin: 0.1,
        square: false,
        callback: (area) {
          final path = SPath(sol.center);

          times(48, (_) {
            path.line(to: sol.randomPoint());
          });

          final curve = path
              .scaled(area.delta.width / size.width)
              .moved(sol.center - area.center)
              .chaikin(n: 3);
          sol.setFillColor(150 + area.index * 5, 80, 70, 20);
          sol.fill(curve);
          sol.draw(curve);
        });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ExampleSix extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Doodles")),
        body: CustomPaint(painter: ExampleSixPainter(), child: Container()));
  }
}
