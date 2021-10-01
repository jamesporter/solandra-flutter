import 'dart:math';
import 'package:fast_noise/fast_noise.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:solandra/solandra.dart';

enum SceneType { Mountains, Hills, Sea }

extension SceneTypeName on SceneType {
  String get name => describeEnum(this);
}

class WallpaperCreatorPainter extends CustomPainter {
  SceneType sceneType;
  int seed;
  final noise = ValueNoise(interp: Interp.Quintic, octaves: 4);

  WallpaperCreatorPainter(this.sceneType, this.seed);

  @override
  void paint(Canvas canvas, Size size) {
    final sol = Solandra(canvas, size, seed: seed);
    sol.clipped();
    sol.background(45, 30, 95);

    sol.setStrokeColor(210, 80, 30, 40);
    sol.strokePaint.strokeWidth = 5;

    switch (sceneType) {
      case SceneType.Mountains:
        _drawMountains(sol);
        break;
      case SceneType.Hills:
        _drawHills(sol);
        break;
      case SceneType.Sea:
        _drawSea(sol);
    }
  }

  void _drawMountains(Solandra sol) {
    sol.background(200, 50, 80);
    times(5, (n) {
      final path = SPath(Point(0, sol.height));
      sol.forHorizontal(
          n: 64,
          margin: -0.1,
          callback: (area) {
            final h = sol.height *
                (0.2 +
                    (4 - n) *
                        (noise.singleValue2(
                            seed + n * 2,
                            4 * (n + 3) * area.center.x / sol.width,
                            area.center.y / sol.height)) /
                        12 +
                    0.1 *
                        (noise.singleValue2(
                            seed + n * 2,
                            48 * area.center.x / sol.width,
                            area.center.y / sol.height)));
            path.line(to: Point(area.origin.x, h + sol.height * 0.2 * n));
          });

      path.line(to: Point(sol.width, sol.height));
      path.close();
      sol.setFillColor(210, 5.0 * n, 20 + 5.0 * n);
      sol.fill(path.chaikin());
    });
  }

  void _drawHills(Solandra sol) {
    sol.background(200, 90, 70);
    times(4, (n) {
      final path = SPath(Point(0, sol.height));
      sol.forHorizontal(
          n: 32,
          margin: -0.1,
          callback: (area) {
            final h = sol.height *
                (0.25 +
                    (8 - n) *
                        (noise.singleValue2(
                            seed + n * 2,
                            4 * (6 - n) * area.center.x / sol.width,
                            area.center.y / sol.height)) /
                        32);
            path.line(to: Point(area.origin.x, h + sol.height * 0.2 * n));
          });

      path.line(to: Point(sol.width, sol.height));
      path.close();
      sol.setFillColor(150 + n * 2.0, 5.0 * n, 20 + 5.0 * n);
      sol.fill(path.chaikin(n: 3));
    });
  }

  void _drawSea(Solandra sol) {
    sol.background(200, 50, 80);
    times(24, (n) {
      final path = SPath(Point(0, sol.height));
      sol.forHorizontal(
          n: 32,
          margin: -0.1,
          callback: (area) {
            final h = sol.height *
                (0.5 +
                    0.01 * n +
                    0.1 * cos(4 * pi * area.center.x / sol.width + n / 2) -
                    0.1 *
                        (noise.singleValue2(
                            seed + n * 2,
                            48 * area.center.x / sol.width,
                            area.center.y / sol.height)));
            path.line(to: Point(area.origin.x, h));
          });

      path.line(to: Point(sol.width, sol.height));
      path.close();
      sol.setFillColor(210, 55.0, 15.0 + n + sol.gaussian(sd: 3), 95);
      sol.fill(path.chaikin(n: 2));
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class WallpaperCreator extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final sceneType = useState<SceneType>(SceneType.Mountains);
    final seed = useState(0);

    return Scaffold(
        appBar: AppBar(title: const Text("Abstract Wallpaper Generator")),
        body: Container(
            child: Column(children: [
          Row(
            children: [
              PopupMenuButton<SceneType>(
                  child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(children: [
                        const Icon(Icons.photo),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          sceneType.value.name,
                          style: TextStyle(fontSize: 20),
                        )
                      ])),
                  itemBuilder: (_) {
                    return SceneType.values
                        .map(
                            (c) => PopupMenuItem(child: Text(c.name), value: c))
                        .toList();
                  },
                  onSelected: (result) {
                    sceneType.value = result;
                  }),
              MaterialButton(
                onPressed: () {
                  seed.value += 1;
                },
                child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text("Seed",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.normal))),
              )
            ],
          ),
          Expanded(
              child: CustomPaint(
                  painter: WallpaperCreatorPainter(sceneType.value, seed.value),
                  child: Container()))
        ])));
  }
}
