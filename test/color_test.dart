import 'package:flutter_test/flutter_test.dart';
import 'package:solandra/util/color.dart';

void main() {
  test('hsla color construction black', () {
    final c = fromHSLA(0, 0, 0, 100);
    expect(c.toString(), "Color(0xff000000)");
  });

  test('hsla color construction white', () {
    final c = fromHSLA(0, 0, 100, 100);
    expect(c.toString(), "Color(0xffffffff)");
  });

  test('hsla color construction red', () {
    final c = fromHSLA(0, 100, 50, 100);
    expect(c.toString(), "Color(0xffff0000)");
  });

  test('hsla color construction blue', () {
    final c = fromHSLA(240, 100, 50, 100);
    expect(c.toString(), "Color(0xff0000ff)");
  });

  test('hsla color construction green', () {
    final c = fromHSLA(120, 100, 50, 100);
    expect(c.toString(), "Color(0xff00ff00)");
  });
}
