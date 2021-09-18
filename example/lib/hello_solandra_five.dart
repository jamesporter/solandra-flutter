import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:solandra/iteration.dart';
import 'package:solandra/path.dart';
import 'package:solandra/solandra.dart';
import 'package:solandra/drawables.dart';
import 'package:solandra/util/convenience.dart';

class ExampleFivePainter extends CustomPainter {
  double controlValue;
  double controlValue2;
  double controlValue3;

  ExampleFivePainter(this.controlValue, this.controlValue2, this.controlValue3);

  @override
  void paint(Canvas canvas, Size size) {
    final sol = Solandra(canvas, size);
    sol.clipped();
    sol.background(45, 40, 90);

    final sp = sol.strokePaint
      ..strokeWidth = controlValue3
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    sol.setStrokeColor(150, 10, 10, 80);

    final a = Point(size.width / 3, size.height / 3);
    final b = Point(2 * size.width / 3, size.height / 3);
    final c = Point(2 * size.width / 3, 2 * size.height / 3);
    final d = Point(size.width / 3, 2 * size.height / 3);

    var path = SPath(a)
      ..line(to: b)
      ..line(to: c)
      ..line(to: d)
      ..close();

    path = path.rotated(controlValue);

    path.exploded(magnitude: controlValue2).forEach((p) {
      sol.setFillColor(180 + sol.gaussian(sd: 40), 90, 50, 50);
      sol.fillD(p);

      p.exploded(magnitude: controlValue2).forEach((q) {
        sol.setFillColor(180 + sol.gaussian(sd: 40), 90, 50, 50);
        sol.fillD(q.rotated(controlValue / 2));
        sol.drawD(q);
      });

      sol.setFillColor(0, 0, 100);
      sol.fillD(DEllipse.circle(p.centroid, 10));
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ExampleFive extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final parameter = useState<double>(0);
    final parameter2 = useState<double>(0);
    final parameter3 = useState<double>(2);

    return Scaffold(
      appBar: AppBar(title: const Text("Circular Animation")),
      body: Container(
          child: Column(children: [
        Row(
          children: [
            Expanded(
                child: Slider(
                    value: parameter.value,
                    onChanged: (newValue) {
                      parameter.value = newValue;
                    },
                    min: 0,
                    max: pi)),
            Expanded(
                child: Slider(
                    value: parameter2.value,
                    onChanged: (newValue) {
                      parameter2.value = newValue;
                    },
                    min: 0,
                    max: 2)),
            Expanded(
                child: Slider(
                    value: parameter3.value,
                    onChanged: (newValue) {
                      parameter3.value = newValue;
                    },
                    min: 1,
                    max: 8)),
          ],
        ),
        Expanded(
            child: CustomPaint(
                painter: ExampleFivePainter(
                    parameter.value, parameter2.value, parameter3.value),
                child: Container()))
      ])),
    );
  }
}
