import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:solandra/path.dart';
import 'package:solandra/solandra.dart';

class CurvesDemo extends CustomPainter {
  double curveSize;
  double curveAngle;
  double bulbousness;
  double twist;
  bool positive;

  CurvesDemo(this.curveSize, this.curveAngle, this.bulbousness, this.twist,
      this.positive);

  @override
  void paint(Canvas canvas, Size size) {
    final sol = Solandra(canvas, size);
    sol.clipped();
    sol.background(200, 20, 95);

    sol.setStrokeColor(sol.random() * 40 + 180, 80, 30, 50);
    sol.setFillColor(210, 90, 40, 10);
    sol.strokePaint.strokeWidth = 5;

    times(20, (_) {
      final path = SPath(sol.center);
      path.curve(
          to: sol.randomPoint(),
          curveSize: curveSize,
          curveAngle: curveAngle,
          bulbousness: bulbousness,
          twist: twist,
          positive: positive);

      sol.draw(path);
      sol.fill(path);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CurvesDemoScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final curveSize = useState<double>(0.5);
    final curveAngle = useState<double>(pi / 4);
    final curveTwist = useState<double>(0);
    final curveBulbousness = useState<double>(0.8);
    final positive = useState<bool>(true);

    return Scaffold(
        appBar: AppBar(title: const Text("Curves")),
        body: Container(
            child: Row(children: [
          Expanded(
              child: CustomPaint(
                  painter: CurvesDemo(curveSize.value, curveAngle.value,
                      curveBulbousness.value, curveTwist.value, positive.value),
                  child: Container())),
          SizedBox(
              width: 220,
              child: Column(
                children: [
                  const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                          "Typical Bezier APIs rely on specifying control points which are relative to both the start and end point locations and size. Solandra's API offers more intuitive parameters, which mean the curve shape is the same independent of start and end locations and size. Here 20 curves are drawn from the center to random positions. The curve shapes are the same and can be intuitively adjusted.")),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                          "Curve Size ${curveSize.value.toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 18))),
                  Slider(
                      value: curveSize.value,
                      onChanged: (newValue) {
                        curveSize.value = newValue;
                      },
                      min: 0,
                      max: 4),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                          "Angle ${curveAngle.value.toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 18))),
                  Slider(
                      value: curveAngle.value,
                      onChanged: (newValue) {
                        curveAngle.value = newValue;
                      },
                      min: -pi * 2,
                      max: pi * 2),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                          "Twist ${curveTwist.value.toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 18))),
                  Slider(
                      value: curveTwist.value,
                      onChanged: (newValue) {
                        curveTwist.value = newValue;
                      },
                      min: 0,
                      max: 2),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                          "Bulbousness ${curveBulbousness.value.toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 18))),
                  Slider(
                      value: curveBulbousness.value,
                      onChanged: (newValue) {
                        curveBulbousness.value = newValue;
                      },
                      min: 0,
                      max: 4),
                  const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("Positive", style: TextStyle(fontSize: 18))),
                  Switch(
                      value: positive.value,
                      onChanged: (newValue) {
                        positive.value = newValue;
                      })
                ],
              ))
        ])));
  }
}
