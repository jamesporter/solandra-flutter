import 'dart:ui';

// Not a natural way to do this see https://github.com/dart-lang/language/issues/723 (proposal to add static methods to extensions)

/// Creates a Color from HSL Conversion formula
/// adapted from http://en.wikipedia.org/wiki/HSV_color_space.
/// Assumes h in [0, 360]
/// s, l and a are in [0, 100]
///
fromHSLA(double h, double s, double l, double a) {
  double r = 0;
  double g = 0;
  double b = 0;

  final chroma = (1 - (2 * l / 100 - 1).abs()) * (s / 100);
  // Take % 360 for wrap around on hue... not really defined but I think in most cases best approach?

  final hDash = (h % 360) / 60;
  final i = hDash.floor();
  final x = chroma * (1 - (hDash % 2 - 1).abs());

  switch (i % 6) {
    case 0:
      r = chroma;
      g = x;
      b = 0;
      break;
    case 1:
      r = x;
      g = chroma;
      b = 0;
      break;
    case 2:
      r = 0;
      g = chroma;
      b = x;
      break;
    case 3:
      r = 0;
      g = x;
      b = chroma;
      break;
    case 4:
      r = x;
      g = 0;
      b = chroma;
      break;
    case 5:
      r = chroma;
      g = 0;
      b = x;
      break;
  }
  final m = (l / 100) - chroma / 2;

  r += m;
  g += m;
  b += m;

  return Color.fromARGB(((a * 255) / 100).floor(), (r * 255).floor(),
      (g * 255).floor(), (b * 255).floor());
}
