import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:solandra/iteration.dart';
import 'package:solandra/solandra.dart';
import 'package:solandra/drawables.dart';
import 'package:solandra/util/convenience.dart';

class ExampleFourPainter extends CustomPainter {
  double animatedValue;
  double controlValue;

  ExampleFourPainter(this.animatedValue, this.controlValue);

  @override
  void paint(Canvas canvas, Size size) {
    final sol = Solandra(canvas, size);
    sol.clipped();
    sol.background(45, 40, 90);

    times(3, (i) {
      sol.setFillColor(controlValue - i * 20, 70, 40, 70);
      final baseR = size.minimum / 12;
      sol.aroundCircle(
          radius: size.minimum / 2.4 - i * size.minimum / 6,
          n: 24 - i * 8,
          callback: (pt, j) {
            sol.fillD(DEllipse.circle(
                pt, baseR * (2 + cos(j + animatedValue / 40)) / 2));
          });
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ExampleFour extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final parameter = useState<double>(0);

    return Scaffold(
      appBar: AppBar(title: const Text("Circular Animation")),
      body: Container(
          child: Column(children: [
        Expanded(
            child: TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 3600 * 60),
                duration: const Duration(seconds: 3600),
                builder: (BuildContext ctx, double value, Widget? _) {
                  return CustomPaint(
                      painter: ExampleFourPainter(value, parameter.value),
                      child: Container());
                })),
        Slider(
            value: parameter.value,
            onChanged: (newValue) {
              parameter.value = newValue;
            },
            min: 0,
            max: 360)
      ])),
    );
  }
}
