import 'package:df_collection/df_collection.dart';
import 'package:test/test.dart';

void main() {
  group('deepGet', () {
    final data = <dynamic, dynamic>{
      'users': [
        {'name': 'Alice', 'age': 30},
        {
          'name': 'Bob',
          'roles': {'editor': true, 'admin': false},
        },
      ],
      '2': 'numeric-string-key',
      'mixed': {
        0: 'zero',
        '0': 'string-zero',
      },
      'deep': {
        'a': {
          'b': {
            'c': {'d': 42},
          },
        },
      },
      'nullValue': null,
    };

    test('returns null for null map', () {
      expect(deepGet(null, 'anything'), isNull);
    });

    test('returns null for empty path on empty map', () {
      expect(deepGet(<dynamic, dynamic>{}, ''), isNull);
    });

    test('reads simple key', () {
      expect(deepGet(data, '2'), 'numeric-string-key');
    });

    test('reads list element via numeric string in path', () {
      expect(deepGet(data, 'users.1.name'), 'Bob');
      expect(deepGet(data, 'users.0.age'), 30);
    });

    test('reads deeply nested map', () {
      expect(deepGet(data, 'deep.a.b.c.d'), 42);
    });

    test('returns null for missing key', () {
      expect(deepGet(data, 'users.99.name'), isNull);
      expect(deepGet(data, 'missing'), isNull);
      expect(deepGet(data, 'deep.x.y.z'), isNull);
    });

    test('returns null for negative index', () {
      expect(deepGet(data, 'users.-1.name'), isNull);
    });

    test('returns null when traversing into a leaf', () {
      expect(deepGet(data, '2.foo'), isNull);
    });

    test('returns null when traversing through null value', () {
      expect(deepGet(data, 'nullValue.foo'), isNull);
    });

    test('respects custom separator', () {
      expect(
        deepGet(data, 'users/1/name', separator: '/'),
        'Bob',
      );
    });

    test('preserves null leaf as null (indistinguishable from missing)', () {
      expect(deepGet(data, 'nullValue'), isNull);
    });
  });

  group('deepGetFromSegments', () {
    test('returns the value with mixed segment types', () {
      final data = <dynamic, dynamic>{
        'list': [10, 20, 30],
      };
      expect(deepGetFromSegments(data, ['list', 1]), 20);
      expect(deepGetFromSegments(data, ['list', '1']), 20);
      expect(deepGetFromSegments(data, ['list', 1.0]), 20);
    });

    test('falls back to map key when current is map (numeric string)', () {
      final data = <dynamic, dynamic>{
        '2': 'A numeric string key',
      };
      expect(deepGetFromSegments(data, ['2']), 'A numeric string key');
    });

    test('returns null when index out of range', () {
      final data = <dynamic, dynamic>{
        'list': [10, 20, 30],
      };
      expect(deepGetFromSegments(data, ['list', 99]), isNull);
      expect(deepGetFromSegments(data, ['list', -1]), isNull);
    });

    test('returns the map itself when path is empty', () {
      final data = <dynamic, dynamic>{'a': 1};
      expect(deepGetFromSegments(data, <dynamic>[]), data);
    });

    test('handles nested iterable inside iterable', () {
      final data = <dynamic, dynamic>{
        'grid': [
          [1, 2],
          [3, 4],
        ],
      };
      expect(deepGetFromSegments(data, ['grid', 1, 0]), 3);
    });

    test('non-numeric string for iterable returns null', () {
      final data = <dynamic, dynamic>{
        'list': [10, 20, 30],
      };
      expect(deepGetFromSegments(data, ['list', 'foo']), isNull);
    });

    test('Map.deepGet extension works identically', () {
      final data = <dynamic, dynamic>{
        'users': [
          {'name': 'Alice'},
        ],
      };
      expect(data.deepGet('users.0.name'), 'Alice');
      expect(data.deepGetFromSegments(['users', 0, 'name']), 'Alice');
    });

    test('refuses to index into a Set (non-deterministic order)', () {
      // Medical-grade: a Set has no defined element order. Returning
      // `elementAt(n)` would be implementation-defined and could differ
      // between runs/platforms. We refuse instead.
      final data = <dynamic, dynamic>{
        'tags': <int>{30, 10, 20, 40},
      };
      expect(deepGetFromSegments(data, ['tags', 0]), isNull);
      expect(deepGetFromSegments(data, ['tags', 1]), isNull);
    });

    test('refuses fractional indices instead of truncating', () {
      // Previously "3.5" silently truncated to 3 — that's silent data
      // corruption. Now it's rejected.
      final data = <dynamic, dynamic>{
        'list': [10, 20, 30, 40],
      };
      expect(deepGetFromSegments(data, ['list', '3.5']), isNull);
      expect(deepGetFromSegments(data, ['list', 1.9]), isNull);
    });

    test('accepts whole-number doubles for indices', () {
      final data = <dynamic, dynamic>{
        'list': [10, 20, 30],
      };
      expect(deepGetFromSegments(data, ['list', 2.0]), 30);
    });
  });
}
