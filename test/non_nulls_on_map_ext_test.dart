import 'package:df_collection/df_collection.dart';
import 'package:test/test.dart';

void main() {
  group('NonNullsOnMapExt.nonNulls', () {
    test('drops entries with null key or null value', () {
      final m = <String?, int?>{
        'a': 1,
        null: 2,
        'b': null,
        'c': 3,
      };
      expect(m.nonNulls, {'a': 1, 'c': 3});
    });

    test('empty map', () {
      expect(<String?, int?>{}.nonNulls, <String, int>{});
    });

    test('all null entries returns empty', () {
      final m = <String?, int?>{null: 1, 'a': null};
      expect(m.nonNulls, <String, int>{});
    });
  });

  group('NonNullKeysOnMapExt.nonNullKeys', () {
    test('drops null-key entries; keeps null values', () {
      final m = <String?, int?>{
        'a': 1,
        null: 2,
        'b': null,
      };
      expect(m.nonNullKeys, {'a': 1, 'b': null});
    });
  });

  group('NonNullValuesOnMapExt.nonNullValues', () {
    test('drops null-value entries; keeps null keys', () {
      final m = <String, int?>{
        'a': 1,
        'b': null,
        'c': 3,
      };
      expect(m.nonNullValues, {'a': 1, 'c': 3});
    });
  });
}
