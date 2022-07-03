import 'dart:typed_data';
import 'dart:ui';

import 'package:solandra/solandra.dart';

/// Flutter has create support for offscreen rendering to images but it is very boilerplate-y.
///
/// Take the result of this and write to file like:
///
/// ```dart
///  final f = File(...);
///  if (bytes != null) {
///    await f.writeAsBytes(bytes);
///  }
/// ```
class SolandraRenderer {
  /// Render an image to write to a file
  static Future<Uint8List?> render(
      {required Size size, required Function(Solandra) render}) async {
    var recorder = PictureRecorder();
    var origin = Offset.zero;

    var paintBounds = Rect.fromPoints(
      origin,
      origin.translate(size.width, size.height),
    );

    final canvas = Canvas(recorder, paintBounds);
    final s = Solandra(canvas, size);
    render(s);

    var picture = recorder.endRecording();
    var image = await picture.toImage(size.width.round(), size.height.round());

    var data = await image.toByteData(format: ImageByteFormat.png);

    return data?.buffer.asUint8List();
  }
}
