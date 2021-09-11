import 'dart:math';
import 'dart:ui';

/// Subclass this for when just wrapping some built in Canvas API
abstract class Drawable {
  draw(Canvas canvas, Paint paint);
}

/// Subclass this to create Drawables from flexible paths
abstract class SPathDrawable extends Drawable {
  // TODO is this pointless... surely could just implement Drawable for SPath???
  Path get path;

  @override
  draw(Canvas canvas, Paint paint) {
    canvas.drawPath(path, paint);
  }
}

class DRect extends Drawable {
  // TODO want to support position as center and TL
  Point<double> position;
  Size size;

  DRect(this.position, this.size);

  @override
  draw(Canvas canvas, Paint paint) {
    canvas.drawRect(
        Rect.fromLTWH(position.x, position.y, size.width, size.height), paint);
  }
}
