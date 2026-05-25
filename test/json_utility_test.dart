import 'package:df_collection/df_collection.dart';
import 'package:test/test.dart';

class _NotJsonable {
  const _NotJsonable();
}

void main() {
  group('JsonUtility.flattenJson', () {
    test('flattens nested maps', () {
      final result = JsonUtility.i.flattenJson({
        'a': {
          'b': {'c': 1},
        },
      });
      expect(result, {'a.b.c': 1});
    });

    test('flattens lists using numeric indices', () {
      final result = JsonUtility.i.flattenJson({
        'list': [10, 20, 30],
      });
      expect(result, {'list.0': 10, 'list.1': 20, 'list.2': 30});
    });

    test('flattens nested map inside list', () {
      final result = JsonUtility.i.flattenJson({
        'emails': [
          {'address': 'a@x.com'},
          {'address': 'b@x.com'},
        ],
      });
      expect(result, {
        'emails.0.address': 'a@x.com',
        'emails.1.address': 'b@x.com',
      });
    });

    test('respects custom separator', () {
      final result = JsonUtility.i.flattenJson(
        {
          'a': {'b': 1},
        },
        separator: '/',
      );
      expect(result, {'a/b': 1});
    });

    test('empty map returns empty map', () {
      expect(JsonUtility.i.flattenJson({}), <String, dynamic>{});
    });

    test('handles scalar at top level', () {
      // Top-level scalar is not really expected per the signature, but a map
      // containing only scalars should pass through.
      final result = JsonUtility.i.flattenJson({'k': 42});
      expect(result, {'k': 42});
    });

    test('preserves null leaf', () {
      final result = JsonUtility.i.flattenJson({
        'k': {'v': null},
      });
      expect(result, {'k.v': null});
    });

    test('preserves empty sub-map as leaf', () {
      final result = JsonUtility.i.flattenJson({
        'a': <String, dynamic>{},
        'b': 1,
      });
      expect(result, {'a': <String, dynamic>{}, 'b': 1});
    });

    test('preserves empty sub-list as leaf', () {
      final result = JsonUtility.i.flattenJson({
        'a': <dynamic>[],
        'b': 1,
      });
      expect(result, {'a': <dynamic>[], 'b': 1});
    });

    test('throws when a key contains the separator (ambiguous flat path)', () {
      // Medical-grade: silently producing an ambiguous flattened path would
      // be a data-integrity bug. Reject up-front so the caller can choose a
      // different separator.
      expect(
        () => JsonUtility.i.flattenJson({'a.b': 1}),
        throwsStateError,
      );
    });

    test('throws on path collision (nested + dotted-key would collide)', () {
      // {'a.b': 1, 'a': {'b': 2}} would flatten BOTH to 'a.b', causing a
      // silent overwrite. Detect and refuse.
      expect(
        () => JsonUtility.i.flattenJson({
          'a.b': 1,
          'a': {'b': 2},
        }),
        throwsA(anyOf(isStateError, isException)),
      );
    });

    test('custom separator allows previously-bad keys', () {
      // With a separator the keys don't contain, flattening is fine.
      final result = JsonUtility.i.flattenJson(
        {
          'a.b': {'c': 1},
        },
        separator: '|',
      );
      expect(result, {'a.b|c': 1});
    });
  });

  group('JsonUtility.expandFlattenedJson', () {
    test('creates suffix entries for each dotted key', () {
      final result = JsonUtility.i.expandFlattenedJson({'a.b.c': 1});
      expect(result['a.b.c'], 1);
      expect(result['b.c'], 1);
      expect(result['c'], 1);
    });

    test('existing keys are not overwritten', () {
      final result = JsonUtility.i.expandFlattenedJson({
        'a.b': 1,
        'b': 99,
      });
      expect(result['b'], 99); // Not overwritten by the suffix from 'a.b'
    });

    test('idempotent for already flat single-key maps', () {
      final result = JsonUtility.i.expandFlattenedJson({'a': 1});
      expect(result, {'a': 1});
    });
  });

  group('JsonUtility.expandJson', () {
    test('flatten + expand round trip on nested', () {
      final result = JsonUtility.i.expandJson({
        'a': {
          'b': {'c': 1},
        },
      });
      expect(result['a.b.c'], 1);
      expect(result['b.c'], 1);
      expect(result['c'], 1);
    });
  });

  group('JsonUtility.mapToJson', () {
    test('round-trips scalar map with string keys', () {
      final result = JsonUtility.i.mapToJson({'a': 1, 'b': 2.5, 'c': true, 'd': 'x'});
      expect(result, {'a': 1, 'b': 2.5, 'c': true, 'd': 'x'});
    });

    test('stringifies non-string keys', () {
      final result = JsonUtility.i.mapToJson({1: 'one', 2: 'two'});
      expect(result, {'1': 'one', '2': 'two'});
    });

    test('DateTime keys use microsecondsSinceEpoch', () {
      final dt = DateTime.utc(2026);
      final result = JsonUtility.i.mapToJson({dt: 'first'});
      expect(result.keys.first, dt.microsecondsSinceEpoch.toString());
    });

    test('recurses into nested maps and lists', () {
      final result = JsonUtility.i.mapToJson({
        'list': [
          {'x': 1},
          {'x': 2},
        ],
      });
      expect(result, {
        'list': [
          {'x': 1},
          {'x': 2},
        ],
      });
    });

    test('rejects unsupported types', () {
      expect(
        () => JsonUtility.i.mapToJson({'k': const _NotJsonable()}),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('allows null values', () {
      expect(JsonUtility.i.mapToJson({'k': null}), {'k': null});
    });

    test('allows null deep inside lists and maps', () {
      final r = JsonUtility.i.mapToJson({
        'list': [1, null, 3],
        'sub': {'a': null},
      });
      expect(r, {
        'list': [1, null, 3],
        'sub': {'a': null},
      });
    });

    test('typesAllowed bypasses unsupported-type check', () {
      final result = JsonUtility.i.mapToJson(
        {'k': const _NotJsonable()},
        typesAllowed: {_NotJsonable},
      );
      expect(result['k'], isA<_NotJsonable>());
    });

    test('keyConverter overrides default', () {
      final result = JsonUtility.i.mapToJson(
        {1: 'one'},
        keyConverter: (k) => 'key_$k',
      );
      expect(result, {'key_1': 'one'});
    });

    test('keyConverter returning null falls back to default/toString', () {
      final result = JsonUtility.i.mapToJson(
        {1: 'one'},
        keyConverter: (_) => null,
      );
      expect(result, {'1': 'one'});
    });

    test('empty map returns empty map', () {
      expect(JsonUtility.i.mapToJson(<String, dynamic>{}), <String, dynamic>{});
    });

    test('rejects NaN doubles (not representable in JSON)', () {
      expect(
        () => JsonUtility.i.mapToJson({'a': double.nan}),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('rejects infinity doubles (not representable in JSON)', () {
      expect(
        () => JsonUtility.i.mapToJson({'a': double.infinity}),
        throwsA(isA<UnsupportedError>()),
      );
      expect(
        () => JsonUtility.i.mapToJson({'a': double.negativeInfinity}),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('rejects NaN inside a nested list', () {
      expect(
        () => JsonUtility.i.mapToJson({
          'list': [1.0, double.nan, 3.0],
        }),
        throwsA(isA<UnsupportedError>()),
      );
    });
  });
}
