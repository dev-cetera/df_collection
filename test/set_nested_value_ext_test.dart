import 'package:df_collection/df_collection.dart';
import 'package:test/test.dart';

void main() {
  group('setNestedValue', () {
    test('creates intermediate maps', () {
      final m = <dynamic, dynamic>{};
      m.setNestedValue(['a', 'b', 'c'], 1);
      expect(m, {
        'a': {
          'b': {'c': 1},
        },
      });
    });

    test('overrides existing leaf', () {
      final m = <dynamic, dynamic>{
        'a': {'b': 1},
      };
      m.setNestedValue(['a', 'b'], 99);
      expect(m['a']['b'], 99);
    });

    test('throws when intermediate is a non-map (no silent overwrite)', () {
      final m = <dynamic, dynamic>{'a': 'IMPORTANT_VALUE_999'};
      expect(
        () => m.setNestedValue(['a', 'b'], 10),
        throwsStateError,
      );
      // Original value untouched.
      expect(m, {'a': 'IMPORTANT_VALUE_999'});
    });

    test('overwriteIntermediates: true replaces non-map intermediate', () {
      final m = <dynamic, dynamic>{'a': 5};
      m.setNestedValue(['a', 'b'], 10, overwriteIntermediates: true);
      expect(m, {
        'a': {'b': 10},
      });
    });

    test('treats existing null intermediate as missing (creates map)', () {
      final m = <dynamic, dynamic>{'a': null};
      m.setNestedValue(['a', 'b'], 10);
      expect(m, {
        'a': {'b': 10},
      });
    });

    test('single-key path sets directly', () {
      final m = <dynamic, dynamic>{};
      m.setNestedValue(['a'], 1);
      expect(m, {'a': 1});
    });

    test('empty keyPath is a no-op', () {
      final m = <dynamic, dynamic>{'a': 1};
      m.setNestedValue(<dynamic>[], 'X');
      expect(m, {'a': 1});
    });

    test('mixed key types', () {
      final m = <dynamic, dynamic>{};
      m.setNestedValue([1, 'b', 3], 'v');
      expect(m, {
        1: {
          'b': {3: 'v'},
        },
      });
    });

    test('value can be null', () {
      final m = <dynamic, dynamic>{};
      m.setNestedValue(['a'], null);
      expect(m, {'a': null});
    });
  });
}
