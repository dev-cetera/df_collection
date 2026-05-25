import 'package:df_collection/df_collection.dart';
import 'package:test/test.dart';

void main() {
  group('traverseMap - read', () {
    final data = <dynamic, dynamic>{
      'a': {
        'b': {'c': 42},
      },
    };

    test('reads nested value', () {
      expect(traverseMap(data, ['a', 'b', 'c']), 42);
    });

    test('returns null for missing intermediate', () {
      expect(traverseMap(data, ['x', 'y']), isNull);
    });

    test('returns null for missing final key', () {
      expect(traverseMap(data, ['a', 'b', 'missing']), isNull);
    });

    test('returns null when path crosses non-map', () {
      expect(traverseMap(data, ['a', 'b', 'c', 'd']), isNull);
    });

    test('empty keys returns null', () {
      expect(traverseMap(data, <dynamic>[]), isNull);
    });
  });

  group('traverseMap - write', () {
    test('creates intermediate maps and sets value', () {
      final buffer = <dynamic, dynamic>{};
      final result = traverseMap(buffer, [1, 2, 3], newValue: 'x');
      expect(buffer, {
        1: {
          2: {3: 'x'},
        },
      });
      expect(result, 'x');
    });

    test('overrides existing leaf', () {
      final buffer = <dynamic, dynamic>{
        'a': {'b': 1},
      };
      traverseMap(buffer, ['a', 'b'], newValue: 99);
      expect(buffer['a']['b'], 99);
    });

    test('returns null when intermediate is non-map (no clobber)', () {
      final buffer = <dynamic, dynamic>{'a': 5};
      final result = traverseMap(buffer, ['a', 'b'], newValue: 10);
      expect(result, isNull);
      expect(buffer, {'a': 5}); // not clobbered
    });

    test('cannot set newValue when newValue is null (treated as read)', () {
      final buffer = <dynamic, dynamic>{
        'a': {'b': 1},
      };
      // Documented limitation: passing newValue: null is the same as reading.
      final result = traverseMap(buffer, ['a', 'b'], newValue: null);
      expect(result, 1);
    });
  });

  group('TraverseMapOnMapExt.traverse', () {
    test('reads via extension', () {
      final data = <dynamic, dynamic>{
        'a': {'b': 7},
      };
      expect(data.traverse(['a', 'b']), 7);
    });

    test('writes via extension', () {
      final data = <dynamic, dynamic>{};
      data.traverse(['x', 'y'], newValue: 'v');
      expect(data, {
        'x': {'y': 'v'},
      });
    });
  });
}
