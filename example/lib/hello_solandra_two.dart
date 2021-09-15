import 'package:flutter/material.dart';
import 'package:solandra/iteration.dart';
import 'package:solandra/solandra.dart';
import 'package:solandra/drawables.dart';

class ExampleTwoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final sol = Solandra(canvas, size);
    sol.clipped();
    sol.background(40, 20, 90);
    sol.forTiling(
        n: 24,
        margin: 0.05,
        callback: (area) {
          sol.setFillColor(area.index.toDouble(), 70, 40);
          sol.fillD(DRect(area.origin, area.delta));
        });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ExampleTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Tiling")),
        body: CustomPaint(painter: ExampleTwoPainter(), child: Container()));
  }
}
