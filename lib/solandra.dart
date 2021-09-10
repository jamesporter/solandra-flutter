library solandra;

import 'dart:html';

import 'package:flutter/widgets.dart';
import 'package:solandra/util/data.dart';
import 'util/color.dart';
import 'package:flutter/painting.dart';

class Solandra {
  Canvas canvas;
  Size size;
  Paint fillPaint = Paint()
    ..color = const Color.fromARGB(255, 32, 32, 32)
    ..style = PaintingStyle.fill;

  Paint strokePaint = Paint()
    ..color = const Color.fromARGB(255, 0, 0, 0)
    ..style = PaintingStyle.stroke;

  Solandra(this.canvas, this.size);

  draw(Path path) {
    canvas.drawPath(path, strokePaint);
  }

  fill(Path path) {
    canvas.drawPath(path, fillPaint);
  }

  setFillColor(double h, double s, double v, {double a = 1.0}) {
    fillPaint.color = Color.fromHSV(h, s, v, a);
  }

  withFrame(Function(Area area) callback, {double? margin}) {
    if (margin != null) {
      // TODO! (use the eventual tiling stuff for this)
    } else {
      callback(
          Area(Point(0, 0), size, Point(size.width / 2, size.height / 2), 0));
    }
  }
}
