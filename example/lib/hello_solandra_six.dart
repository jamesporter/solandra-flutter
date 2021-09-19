import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:solandra/iteration.dart';
import 'package:solandra/path.dart';
import 'package:solandra/solandra.dart';

class ExampleSixPainter extends CustomPainter {
  bool square;
  ExampleSixPainter(this.square);

  @override
  void paint(Canvas canvas, Size size) {
    final sol = Solandra(canvas, size);
    sol.clipped();
    sol.background(45, 30, 95);

    sol.forTiling(
        n: 5,
        margin: 0.1,
        square: square,
        callback: (area) {
          final path = SPath(sol.center);

          times(48, (_) {
            path.line(to: sol.randomPoint());
          });

          sol.setFillColor(150 + area.index * 5, 80, 70, 20);

          sol.fill(SPath.rect(at: area.center, size: area.delta, centered: true)
              .scaled(0.9, about: area.center));
          final curve = path
              .scaled(area.delta.width / size.width, about: sol.center)
              .moved(area.center - sol.center)
              .chaikin(n: 3);

          sol.fill(curve);
          sol.draw(curve);
        });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ExampleSix extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final square = useState(false);

    return Scaffold(
      appBar: AppBar(title: const Text("Doodles")),
      body: CustomPaint(
          painter: ExampleSixPainter(square.value), child: Container()),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.crop_square_sharp),
        onPressed: () {
          square.value = !square.value;
        },
      ),
    );
  }
}
