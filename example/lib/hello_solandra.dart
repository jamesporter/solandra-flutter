import 'package:flutter/material.dart';
import 'package:solandra/iteration.dart';
import 'package:solandra/solandra.dart';
import 'package:solandra/drawables.dart';

class ExampleOnePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final sol = Solandra(canvas, size);
    sol.clipped();
    sol.background(100, 1, 90);
    times(32, (_) {
      sol.setFillColor(sol.sample([190, 210, 220]), 80, 50, 50);
      sol.fillD(DEllipse.circle(sol.randomPoint(),
          sol.gaussian(sd: size.width / 12, mean: size.width / 2)));
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ExampleOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Simple Drawing")),
        body: CustomPaint(painter: ExampleOnePainter(), child: Container()));
  }
}
