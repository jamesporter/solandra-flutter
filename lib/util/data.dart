import 'dart:math';
import 'package:flutter/painting.dart';

class Area {
  Point<double> origin;
  Size delta;
  Point<double> center;
  int index;

  Area(this.origin, this.delta, this.center, this.index);
}

class Case {
  double proportion;
  Function() callback;

  Case(this.proportion, this.callback);
}
