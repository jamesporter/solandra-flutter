import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:solandra/iteration.dart';
import 'package:solandra/path.dart';
import 'package:solandra/solandra.dart';

class ExampleSevenPainter extends CustomPainter {
  double parameter;

  ExampleSevenPainter(this.parameter);

  @override
  void paint(Canvas canvas, Size size) {
    final sol = Solandra(canvas, size);
    sol.clipped();
    sol.background(45, 30, 95);

    sol.setStrokeColor(210, 80, 30, 40);
    sol.strokePaint.strokeWidth = 5;

    final n = parameter.round();

    sol.draw(SPath.spiral(
            at: sol.center, n: 300, l: sol.size.magnitude / 50, rate: parameter)
        .chaikin(n: 2));

    sol.setFillColor(20, 80, 50, 30);
    sol.fill(SPath.star(radius: sol.size.magnitude / 4, at: sol.center, n: n));

    sol.setFillColor(50, 80, 50, 30);
    sol.fill(SPath.regularPolygon(
        radius: sol.size.magnitude / 8, at: sol.center, n: n));

    sol.setFillColor(220, 70, 30, 20);
    sol.fill(SPath.rect(at: sol.center, size: size / 5, centered: true));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ExampleSeven extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final parameter = useState<double>(6);

    return Scaffold(
        appBar: AppBar(title: const Text("Fancier Shapes")),
        body: Container(
            child: Column(children: [
          Slider(
              value: parameter.value,
              onChanged: (newValue) {
                parameter.value = newValue;
              },
              min: 4,
              max: 20),
          Expanded(
              child: CustomPaint(
                  painter: ExampleSevenPainter(parameter.value),
                  child: Container()))
        ])));
  }
}
