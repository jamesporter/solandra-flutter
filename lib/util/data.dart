import 'dart:math';
import 'package:flutter/painting.dart';

/// A simple class for (rectangular) parts of a canvas. Makes it easy to iterate over a canvas.
class Area {
  Point<double> origin;
  Size delta;
  Point<double> center;
  int index;

  Area(this.origin, this.delta, this.center, this.index);
}

/// A simple class to contain options for when have several possible actions and want to do one randomly
class Case {
  double proportion;
  Function() callback;

  Case(this.proportion, this.callback);
}
