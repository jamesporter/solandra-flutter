import 'dart:ui';

/// Creates a Color from HSV Conversion formula
/// adapted from http://en.wikipedia.org/wiki/HSV_color_space.
/// Assumes h in [0, 360]
/// s, v and a are in [0, 100]
///
fromHSVA(double h, double s, double v, double a) {
  double r = 0;
  double g = 0;
  double b = 0;

  int i = (h / 60).floor();
  double f = (h / 60) - i;
  double p = (v / 100) * (1 - (s / 100));
  double q = (v / 100) * (1 - f * (s / 100));
  double t = (v / 100) * (1 - (1 - f) * (s / 100));

  switch (i % 6) {
    case 0:
      r = v;
      g = t;
      b = p;
      break;
    case 1:
      r = q;
      g = v;
      b = p;
      break;
    case 2:
      r = p;
      g = v;
      b = t;
      break;
    case 3:
      r = p;
      g = q;
      b = v;
      break;
    case 4:
      r = t;
      g = p;
      b = v;
      break;
    case 5:
      r = v;
      g = p;
      b = q;
      break;
  }

  return Color.fromARGB(((a * 255) / 100).floor(), (r * 255).floor(),
      (g * 255).floor(), (b * 255).floor());
}
