import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:solandra/iteration.dart';
import 'package:solandra/path.dart';
import 'package:solandra/solandra.dart';
import 'package:solandra/drawables.dart';
import 'package:solandra/util/convenience.dart';

class ExampleSixPainter extends CustomPainter {
  ExampleSixPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final sol = Solandra(canvas, size);
    sol.clipped();
    sol.background(45, 40, 90);

    final path = SPath(sol.center);

    times(100, (_) {
      path.line(to: sol.randomPoint());
    });

    final curve = path.chaikin(n: 4);
    sol.setFillColor(150, 80, 70, 20);
    sol.fillD(curve);
    sol.drawD(curve);
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
        appBar: AppBar(title: const Text("Circular Animation")),
        body: CustomPaint(painter: ExampleSixPainter(), child: Container()));
  }
}
