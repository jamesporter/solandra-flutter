Creating graphics with code is fun, but sometimes there is a lot of boilerplate. `Solandra` is a Flutter re-imagining of a [TypeScript library for HTML 5 Canvas drawing](https://solandra.netlify.app/).

Flutter is a performant, multi platform framework with a great developer experience (for example supporting hot reload and declarative UI) but is often verbose. Paired with Solandra you can quickly create interesting, creative 2D graphics applications and deploy to native mobile apps, the web and native desktop apps.

## Solandra is ideal for

- 2D creative code/algorithmic art
- Data visualizations
- Fun animations for (Flutter) Apps

## Features

- Easy, canvas aware iteration
- Easy randomness
- A higher level (S)Path Class (something that you can perform operations on and draw)
- Human friendly HSL(A) Color
- Lots of convenience functions to save you time and boilerplate

Solandra emphasizes short (low boilerplate), clear and thus agile (changeable over time) code. It should allow you to be a lot more productive.

## Demo App

In `./example` or just look at the: [live web version](https://solandra-flutter.netlify.app).

## Getting started

Install the `solandra` package in usual way, see [Solandra package details](https://pub.dev/packages/solandra). For Flutter.

## Usage

Main import via:

```dart
import 'package:solandra/solandra.dart';
```

Create the main helper object like (assumed to be used in `CustomPainter` subclass):

```dart
class Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final sol = Solandra(canvas, size);
```

## Core Parts

The following are the core elements of Solandra (for Flutter).

### Paint Setup for filling and drawing

Solandra sets up a `fillPaint` and `strokePaint` for drawing with on `Solandra` instances. You can directly manipulate them, though for basic colors you can use the helpers described in the next section.

Typically you will draw/fill stuff with

```dart
draw(SPath path)
fill(SPath path)
```

This uses Solandra's `SPath`.

For using Dart's `Path`, instead use:

```dart
drawPath(Path path)
fillPath(Path path)
```

### HSL(A) Color

Colors for the above paints and background can be set via HSL(A) methods. This is much easier to work with than RGB.

Assumes H(ue) from 0 to 360, and S(aturation), L(ightness) and A(lpha) (optional) from 0 to 100. All take `double`s, as this is more flexible/often what you want when doing creative coding.

### Programmable (S)Path Class

There is an `SPath` class that allows you to create paths from lines and curves and then do higher level operations on those paths.

The curves API has an unconventional approach that should be easier to reason about in most cases (under the hood it uses cubic beziers but you describe the size, angle, bulbous-ness and twist of the curve, rather that control points; if you move the points the curve scales in a natural way). [Read more (and see interactive demos) about the ideas behind this approach to curves](https://www.amimetic.co.uk/art/bezier).

Given a path you can perform a number of operations on it, such as applying the Chaikin algorithm to smooth out paths or moving, scaling or otherwise transforming a path.

### Canvas/Size aware iteration

`Solandra` has methods like `forTiling`, `forHorizontal` and more that give you a way to iterate over the canvas with optional margin.

### Unified Random Number Generation (with support for several common distributions)

Random variation is a key part of creative coding and `Solandra` has a wide range of built in functionality that will save you a lot of time. The `randomPoint` method takes into account the `Canvas` size in the obvious way.

```dart
Point<double> randomPoint()
double randomAngle()
double random()
int randomInt(int max)
bool randomBool()
double gaussian({double mean = 0, double sd = 1})
int poisson(int lambda)
T sample<T>(List<T> items)
List<T> samples<T>(List<T> items, int count)
doProportion(double proportion, Function() callback)
proportionately(List<Case> cases)
Point<double> perturb(
    {required Point<double> at, required double magnitude})
List<T> shuffle<T>(List<T> items)
```

### Convenience Helpers

There are some helpers for converting between Dart/Flutter's classes. There are also some miscellaneous things in `Solandra`:

```dart
  clipped()
  double get aspectRatio
  double get width
  double get height
  Point<double> get center
```

Most of these are obvious. The `clipped` method clips drawing to the `Canvas` (in Flutter drawing is not restricted to the `Canvas`'s `Size`).

## What is not included (versus the TypeScript version)?

The library is much simpler in general, as Dart has a lot more built in functionality for mathematics e.g. `Point`, `Size` classes and so on.

Unlike the original TypeScript version there is explicit support for time (you are expected to use Flutter's existing animation tools for that).

## Dart/Flutter Tips

If you are new to either here are some notes:

- `forEachIndexed` exists but you must `import 'package:collection/collection.dart';`
- `expanded` is the Dart version of `flatMap`
- Check out `flutter_hooks` for a nicer way to add state to Widgets
