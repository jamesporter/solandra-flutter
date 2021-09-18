import 'dart:math';
import 'dart:ui';

// TODO I think just remove... adding some constructors to SPath which covers most of what might go here
//for circles etc people can just use the built in Flutter canvas API/no point in doing stuff here

/// Subclass this for when just wrapping some built in Canvas API
abstract class Drawable {
  draw(Canvas canvas, Paint paint);
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

class DEllipse extends Drawable {
  Point<double> position;
  late Size size;

  DEllipse(this.position, this.size);

  DEllipse.circle(this.position, double radius) {
    size = Size(radius, radius);
  }

  @override
  draw(Canvas canvas, Paint paint) {
    canvas.drawOval(
        Rect.fromLTWH(position.x - size.width / 2, position.y - size.height / 2,
            size.width, size.height),
        paint);
  }
}
