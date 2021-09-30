import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:solandra/iteration.dart';
import 'package:solandra/path.dart';
import 'package:solandra/solandra.dart';

enum SceneType { Mountains, Hills, Sea }

extension SceneTypeName on SceneType {
  String get name => describeEnum(this);
}

class WallpaperCreatorPainter extends CustomPainter {
  SceneType sceneType;

  WallpaperCreatorPainter(this.sceneType);

  @override
  void paint(Canvas canvas, Size size) {
    final sol = Solandra(canvas, size);
    sol.clipped();
    sol.background(45, 30, 95);

    sol.setStrokeColor(210, 80, 30, 40);
    sol.strokePaint.strokeWidth = 5;
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

    return Scaffold(
        appBar: AppBar(title: const Text("Fancier Shapes")),
        body: Container(
            child: Column(children: [
          Row(
            children: [
              PopupMenuButton<SceneType>(
                  // child: const Text("Scene"),
                  icon: const Icon(Icons.photo),
                  itemBuilder: (_) {
                    return SceneType.values
                        .map(
                            (c) => PopupMenuItem(child: Text(c.name), value: c))
                        .toList();
                  },
                  onSelected: (result) {
                    sceneType.value = result;
                  }),
              Text(sceneType.value.name)
            ],
          ),
          Expanded(
              child: CustomPaint(
                  painter: WallpaperCreatorPainter(sceneType.value),
                  child: Container()))
        ])));
  }
}
