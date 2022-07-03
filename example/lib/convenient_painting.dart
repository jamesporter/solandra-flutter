import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:solandra/solandra.dart';

/// See [ConvenientPainting2] for an even more concise approach where there is no need to create any additional classes for drawing.
class ConvenientPainter extends SolandraCustomPainter {
  final double param;

  ConvenientPainter(this.param);

  @override
  void sPaint(Solandra s, Size size) {
    s.background(200, 60, 40);

    times(10, (n) {
      SPath.regularPolygon(radius: param * size.width / 4, at: s.center)
          .exploded(magnitude: (n + 1).toDouble() / 5, scale: 1 + param / 3)
          .forEach((path) {
        s.setFillColor(200, 60, 90, 20 - n.toDouble());
        s.fill(path);
      });
    });
  }
}

class ConvenientPainting extends HookWidget {
  const ConvenientPainting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final param = useState(0.4);

    return Scaffold(
        appBar: AppBar(title: const Text("Convenient Painting")),
        body: Column(children: [
          Slider(
              value: param.value,
              onChanged: (v) {
                param.value = v;
              },
              min: 0,
              max: 1),
          SolandraPaintingWidget(painter: ConvenientPainter(param.value))
        ]));
  }
}

/// See [ConvenientPainting] for a more explicit approach, but typically you should just use this approach.
class ConvenientPainting2 extends HookWidget {
  const ConvenientPainting2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final a = useState(1.0);
    final b = useState(0.3);
    final c = useState(0.0);

    void draw(Solandra s) {
      s.clipped();
      s.background(200, 60, 10);

      [a.value, b.value, c.value].forEach((v) {
        final p = SPath.spiral(
                at: s.center,
                n: 100,
                l: s.width / 10,
                rate: 10 + 10 * v,
                startAngle: v * pi * 2)
            .chaikin(n: 2);
        s.setStrokeColor(360 * v, 60, 80, 80);
        s.strokePaint.strokeWidth = s.height / 32;
        s.draw(p);
      });
    }

    return Scaffold(
        appBar: AppBar(title: const Text("More Convenient Painting")),
        body: Row(children: [
          SolandraSimplePaintingWidget(draw: draw),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 240,
              child: Column(children: [
                Slider(
                    value: a.value,
                    onChanged: (v) {
                      a.value = v;
                    },
                    min: 0,
                    max: 1),
                Slider(
                    value: b.value,
                    onChanged: (v) {
                      b.value = v;
                    },
                    min: 0,
                    max: 1),
                Slider(
                    value: c.value,
                    onChanged: (v) {
                      c.value = v;
                    },
                    min: 0,
                    max: 1),
                const Text(
                    "See the source code for this button, shows how you could render a PNG image from the same code used for drawing here"),
                ElevatedButton(
                    onPressed: () async {
                      final bytes = await SolandraRenderer.render(
                          size: const Size(320, 320), render: draw);
                      if (bytes != null) {
                        // For example write to file
                      }
                    },
                    child: const Text("Render"))
              ]),
            ),
          ),
        ]));
  }
}
