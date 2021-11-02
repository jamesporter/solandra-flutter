import 'package:example/curves_demo.dart';
import 'package:example/hello_solandra.dart';
import 'package:example/hello_solandra_five.dart';
import 'package:example/hello_solandra_four.dart';
import 'package:example/hello_solandra_seven.dart';
import 'package:example/hello_solandra_six.dart';
import 'package:example/hello_solandra_three.dart';
import 'package:example/hello_solandra_two.dart';
import 'package:example/home_screen.dart';
import 'package:example/wallpaper_creator.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext ctx)> examples = {
  "Slideshow": (_) => ExampleOne(),
  "Tiling": (_) => ExampleTwo(),
  "Simple Animation": (_) => ExampleThree(),
  "Circular Animation": (_) => ExampleFour(),
  "(S)Path Operations": (_) => ExampleFive(),
  "Doodles": (_) => ExampleSix(),
  "Fancier Shapes": (_) => ExampleSeven(),
  "Wallpaper Creator": (_) => WallpaperCreator(),
  "Understanding Curves": (_) => CurvesDemoScreen()
};

Map<String, Widget Function(BuildContext ctx)> routes() {
  Map<String, Widget Function(BuildContext ctx)> routeMap = {
    "/": (_) => HomeScreen()
  };
  var i = 1;
  examples.forEach((key, value) {
    routeMap["/$i"] = value;
    i++;
  });
  return routeMap;
}

List<String> routeNames() {
  List<String> names = [];
  examples.forEach((key, value) {
    names.add(key);
  });
  return names;
}

final examplesCount = examples.length;
