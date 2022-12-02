import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:test_roulette/resources/resources.dart';

void main() {
  test('svgs assets test', () {
    expect(File(Svgs.europeanRouletteWheel).existsSync(), true);
    expect(File(Svgs.arrow).existsSync(), true);
    expect(File(Svgs.coin).existsSync(), true);
    expect(File(Svgs.defaultUserImage).existsSync(), true);
    expect(File(Svgs.minus).existsSync(), true);
    expect(File(Svgs.plus).existsSync(), true);
  });
}
