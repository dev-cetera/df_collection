import 'package:df_collection/df_collection.dart';
import 'package:test/test.dart';

void main() {
  group('ToMapOnIterableExt.toMap', () {
    test('builds map from entries', () {
      final entries = [
        const MapEntry('a', 1),
        const MapEntry('b', 2),
      ];
      expect(entries.toMap(), {'a': 1, 'b': 2});
    });

    test('last value wins on key collision', () {
      final entries = [
        const MapEntry('a', 1),
        const MapEntry('a', 99),
      ];
      expect(entries.toMap(), {'a': 99});
    });

    test('empty iterable returns empty map', () {
      expect(<MapEntry<String, int>>[].toMap(), <String, int>{});
    });
  });
}
