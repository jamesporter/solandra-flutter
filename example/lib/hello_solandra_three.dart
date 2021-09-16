import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:solandra/iteration.dart';
import 'package:solandra/solandra.dart';
import 'package:solandra/drawables.dart';

class ExampleThreePainter extends CustomPainter {
  double animatedValue;

  ExampleThreePainter(this.animatedValue);

  @override
  void paint(Canvas canvas, Size size) {
    final sol = Solandra(canvas, size);
    sol.clipped();
    sol.background(40, 20, 90);

    times(24, (i) {
      sol.setFillColor(210, 70, 40, sol.gaussian(sd: 3, mean: 10));
      sol.fillD(DEllipse.circle(
          sol.randomPoint(),
          32 +
              32 *
                  cos(animatedValue / 100 + i).abs() *
                  sol.gaussian(sd: 5, mean: 20)));
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ExampleThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Simple Animation")),
      body: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 3600 * 60),
          duration: const Duration(seconds: 3600),
          builder: (BuildContext ctx, double value, Widget? _) {
            return CustomPaint(
                painter: ExampleThreePainter(value), child: Container());
          }),
    );
  }
}
