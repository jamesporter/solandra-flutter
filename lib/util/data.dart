import 'dart:math';
import 'package:flutter/painting.dart';

class Area {
  Point origin;
  Size delta;
  Point center;
  int index;

  Area(this.origin, this.delta, this.center, this.index);
}
