import 'package:df_collection/df_collection.dart';
import 'package:test/test.dart';

void main() {
  group('nullFilteredMap', () {
    test('drops null keys and values when types are non-null', () {
      final input = <dynamic, dynamic>{
        'a': 1,
        null: 2,
        'b': null,
        'c': 3,
      };
      final result = nullFilteredMap<String, int>(input);
      expect(result, {'a': 1, 'c': 3});
    });

    test('keeps nulls when type parameter is nullable', () {
      final input = <dynamic, dynamic>{'a': 1, 'b': null};
      final result = nullFilteredMap<String, int?>(input);
      expect(result, {'a': 1, 'b': null});
    });

    test('empty map returns empty', () {
      expect(
        nullFilteredMap<String, int>(<dynamic, dynamic>{}),
        <String, int>{},
      );
    });

    test('mismatched element types throw on cast', () {
      // Filtering keeps these but the cast as K/V will throw.
      expect(
        () => nullFilteredMap<String, int>(<dynamic, dynamic>{'a': 'not-int'}),
        throwsA(isA<TypeError>()),
      );
    });
  });

  group('nullFilteredList', () {
    test('drops nulls when type is non-null', () {
      expect(nullFilteredList<int>(<dynamic>[1, null, 2, null]), [1, 2]);
    });

    test('keeps nulls when type is nullable', () {
      expect(nullFilteredList<int?>(<dynamic>[1, null, 2]), [1, null, 2]);
    });

    test('empty input', () {
      expect(nullFilteredList<int>(<dynamic>[]), <int>[]);
    });
  });

  group('nullFilteredSet', () {
    test('drops nulls when type is non-null', () {
      expect(
        nullFilteredSet<int>(<dynamic>[1, null, 2, 1]),
        {1, 2},
      );
    });

    test('keeps nulls when type is nullable', () {
      expect(
        nullFilteredSet<int?>(<dynamic>[1, null, 2]),
        {1, null, 2},
      );
    });
  });
}
