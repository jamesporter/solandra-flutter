import 'package:flutter/material.dart';
import 'package:solandra/solandra.dart';

/// simple custom painting widget; takes all available space and allows for drawing with Solandra.
/// Can use with a subclass of [SolandraCustomPainter].
class SolandraPaintingWidget extends StatelessWidget {
  final CustomPainter painter;

  const SolandraPaintingWidget({Key? key, required this.painter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: CustomPaint(
            painter: painter,
            // need child to take size
            child: Container()));
  }
}

abstract class SolandraCustomPainter extends CustomPainter {
  void sPaint(Solandra s, Size size);

  @override
  void paint(Canvas canvas, Size size) {
    final s = Solandra(canvas, size);
    sPaint(s, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  /// Override to customize this
  int get seed => 0;
}

/// A very convenient way to draw with Flutter and Solandra.
///
/// Simple custom painting widget; takes all available space (so you will likely need to
/// put it inside something else like a [Column] or [Row]).
///
class SolandraSimplePaintingWidget extends SolandraPaintingWidget {
  final Function(Solandra) draw;

  SolandraSimplePaintingWidget({
    Key? key,
    required this.draw,
  }) : super(key: key, painter: SolandraSimplePainting(draw));
}

class SolandraSimplePainting extends SolandraCustomPainter {
  final Function(Solandra) draw;
  late final int? seedValue;

  SolandraSimplePainting(this.draw, {int? seed}) {
    seedValue = seed;
  }

  @override
  void sPaint(Solandra s, Size size) {
    draw(s);
  }

  @override
  int get seed => seedValue ?? 0;
}
