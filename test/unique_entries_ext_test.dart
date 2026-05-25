import 'package:df_collection/df_collection.dart';
import 'package:test/test.dart';

void main() {
  group('uniqueEntries', () {
    test('keeps only entries with unique keys and values', () {
      final entries = [
        const MapEntry('a', 1),
        const MapEntry('a', 2), // dup key
        const MapEntry('b', 1), // dup value (1)
        const MapEntry('c', 3),
      ];
      final result = entries.uniqueEntries();
      expect(result.length, 2);
      expect(result[0].key, 'a');
      expect(result[0].value, 1);
      expect(result[1].key, 'c');
      expect(result[1].value, 3);
    });

    test('empty input', () {
      expect(<MapEntry<String, int>>[].uniqueEntries(), isEmpty);
    });

    test('single element kept', () {
      final entries = [const MapEntry('a', 1)];
      final r = entries.uniqueEntries();
      expect(r.length, 1);
      expect(r[0].key, 'a');
      expect(r[0].value, 1);
    });
  });

  group('uniqueKeys', () {
    test('keeps first entry per key', () {
      final entries = [
        const MapEntry('a', 1),
        const MapEntry('a', 2),
        const MapEntry('b', 3),
      ];
      final result = entries.uniqueKeys();
      expect(result.length, 2);
      expect(result[0].value, 1);
      expect(result[1].key, 'b');
    });

    test('all unique keys preserved', () {
      final entries = [
        const MapEntry('a', 1),
        const MapEntry('b', 2),
      ];
      expect(entries.uniqueKeys().length, 2);
    });
  });

  group('uniqueValues', () {
    test('keeps first entry per value', () {
      final entries = [
        const MapEntry('a', 1),
        const MapEntry('b', 1),
        const MapEntry('c', 2),
      ];
      final result = entries.uniqueValues();
      expect(result.length, 2);
      expect(result[0].key, 'a');
      expect(result[1].key, 'c');
    });
  });
}
