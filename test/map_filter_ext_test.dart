import 'package:df_collection/df_collection.dart';
import 'package:test/test.dart';

void main() {
  group('mapWithDefault', () {
    test('replaces nulls with default', () {
      final m = <String, int?>{'a': 1, 'b': null, 'c': 3};
      expect(m.mapWithDefault(0), {'a': 1, 'b': 0, 'c': 3});
    });

    test('default null returns a copy', () {
      final m = <String, int?>{'a': 1, 'b': null};
      final r = m.mapWithDefault(null);
      expect(r, {'a': 1, 'b': null});
      expect(identical(r, m), isFalse); // It's a copy
    });

    test('empty map', () {
      expect(<String, int?>{}.mapWithDefault(0), <String, int>{});
    });
  });

  group('filterByIncludedValues', () {
    test('keeps matching values', () {
      final m = {'a': 1, 'b': 2, 'c': 3};
      expect(m.filterByIncludedValues([1, 3]), {'a': 1, 'c': 3});
    });

    test('empty include list filters everything out', () {
      expect({'a': 1}.filterByIncludedValues([]), <String, int>{});
    });
  });

  group('filterByExcludedValues', () {
    test('drops matching values', () {
      final m = {'a': 1, 'b': 2, 'c': 3};
      expect(m.filterByExcludedValues([2]), {'a': 1, 'c': 3});
    });

    test('empty exclude list keeps everything', () {
      expect({'a': 1, 'b': 2}.filterByExcludedValues([]), {'a': 1, 'b': 2});
    });
  });

  group('filterByIncludedKeys', () {
    test('keeps matching keys', () {
      final m = {'a': 1, 'b': 2, 'c': 3};
      expect(m.filterByIncludedKeys(['a', 'c']), {'a': 1, 'c': 3});
    });

    test('non-existent included keys are ignored', () {
      expect({'a': 1}.filterByIncludedKeys(['nope']), <String, int>{});
    });
  });

  group('filterByExcludedKeys', () {
    test('drops matching keys', () {
      final m = {'a': 1, 'b': 2, 'c': 3};
      expect(m.filterByExcludedKeys(['b']), {'a': 1, 'c': 3});
    });

    test('empty exclude list keeps everything', () {
      expect({'a': 1, 'b': 2}.filterByExcludedKeys([]), {'a': 1, 'b': 2});
    });
  });
}
