import 'package:flutter_test/flutter_test.dart';

import 'package:espertinhos/models/scoring.dart';

void main() {
  test('starsFromMistakes gives 5 stars with no mistakes', () {
    expect(starsFromMistakes(0), 5);
    expect(starsFromMistakes(4), 1);
  });

  test('starsFromEfficiency rewards fewer moves', () {
    expect(starsFromEfficiency(4, 4), 5);
    expect(starsFromEfficiency(20, 4), 1);
  });
}
