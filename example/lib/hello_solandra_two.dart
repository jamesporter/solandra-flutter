import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:solandra/solandra.dart';
import 'package:solandra/drawables.dart';

class ExampleTwoPainter extends CustomPainter {
  bool columnFirst;

  ExampleTwoPainter(this.columnFirst);

  @override
  void paint(Canvas canvas, Size size) {
    final sol = Solandra(canvas, size);
    sol.clipped();
    sol.background(40, 20, 90);
    sol.forTiling(
        n: 32,
        margin: 0.05,
        columnFirst: columnFirst,
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

class ExampleTwo extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final colFirst = useState(false);
    return Scaffold(
      appBar: AppBar(title: const Text("Tiling")),
      body: CustomPaint(
          painter: ExampleTwoPainter(colFirst.value), child: Container()),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.crop_rotate),
        onPressed: () {
          colFirst.value = !colFirst.value;
        },
      ),
    );
  }
}
