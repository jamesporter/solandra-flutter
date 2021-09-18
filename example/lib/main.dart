import 'package:example/hello_solandra.dart';
import 'package:example/hello_solandra_five.dart';
import 'package:example/hello_solandra_four.dart';
import 'package:example/hello_solandra_seven.dart';
import 'package:example/hello_solandra_six.dart';
import 'package:example/hello_solandra_three.dart';
import 'package:example/hello_solandra_two.dart';
import 'package:example/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.amber,

          // Workaround for bug in 2.5 Desktop (see https://github.com/flutter/flutter/issues/88221 ):
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: <TargetPlatform, PageTransitionsBuilder>{
              TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
              TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
            },
          )),
      routes: {
        "/": (_) => HomeScreen(),
        "/1": (_) => ExampleOne(),
        "/2": (_) => ExampleTwo(),
        "/3": (_) => ExampleThree(),
        "/4": (_) => ExampleFour(),
        "/5": (_) => ExampleFive(),
        "/6": (_) => ExampleSix(),
        "/7": (_) => ExampleSeven()
      },
      // showPerformanceOverlay: true,
      debugShowCheckedModeBanner: false,
    );
  }
}
