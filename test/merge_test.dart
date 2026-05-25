import 'dart:collection' show Queue;

import 'package:df_collection/df_collection.dart';
import 'package:test/test.dart';

class _ToJsonable {
  _ToJsonable(this.x);
  final int x;
  Map<String, dynamic> toJson() => {'x': x};
}

class _Mappable {
  _Mappable(this.y);
  final int y;
  Map<String, dynamic> toMap() => {'y': y};
}

class _BrokenToJson {
  Map<String, dynamic> toJson() => throw StateError('boom');
}

void main() {
  group('mergeIterables', () {
    test('merges two lists ignoring nulls', () {
      final merged = mergeIterables([1, null, 2], [null, 3]);
      expect(merged.toList(), [1, 2, 3]);
    });

    test('wraps non-iterables', () {
      final merged = mergeIterables(1, 2);
      expect(merged.toList(), [1, 2]);
    });

    test('mixes iterable and scalar', () {
      expect(mergeIterables([1, 2], 3).toList(), [1, 2, 3]);
      expect(mergeIterables(1, [2, 3]).toList(), [1, 2, 3]);
    });

    test('both empty', () {
      expect(mergeIterables(<int>[], <int>[]).toList(), isEmpty);
    });
  });

  group('mergeListsSetsOrQueues', () {
    test('two lists - b overwrites a positionally, a remainder kept', () {
      final merged = mergeListsSetsOrQueues(
        [1, 2, 3],
        [10, 20],
      ).toList();
      // b's scalar overwrites a's scalar at the same position; index 2 (3) kept.
      expect(merged, [10, 20, 3]);
    });

    test('list b longer than a appends extras', () {
      final merged = mergeListsSetsOrQueues(
        [1, 2],
        [10, 20, 30],
      ).toList();
      expect(merged, [10, 20, 30]);
    });

    test('two sets unite without duplicates', () {
      final merged = mergeListsSetsOrQueues({1, 2}, {2, 3});
      expect(merged, isA<Set<dynamic>>());
      expect(merged, unorderedEquals(<dynamic>[1, 2, 3]));
    });

    test('set branch applies elseFilter to b items', () {
      final merged = mergeListsSetsOrQueues(
        {1, 2},
        [3, 4],
        (v) => 'X$v',
      );
      expect(merged, unorderedEquals(<dynamic>[1, 2, 'X3', 'X4']));
    });

    test('two queues element-wise merged into queue', () {
      final merged = mergeListsSetsOrQueues(
        Queue<int>.of([1, 2]),
        Queue<int>.of([10, 20, 30]),
      );
      expect(merged, isA<Queue<dynamic>>());
      expect(merged.toList(), [10, 20, 30]);
    });

    test('nested maps inside lists merge deeply', () {
      final merged = mergeListsSetsOrQueues(
        [
          {'a': 1},
        ],
        [
          {'b': 2},
        ],
      ).toList();
      expect(merged, [
        {'a': 1, 'b': 2},
      ]);
    });

    test('elseFilter applied on element-wise replacement', () {
      final merged = mergeListsSetsOrQueues(
        [1, 2],
        ['a', 'b'],
        (v) => 'X$v',
      ).toList();
      // b overwrites a positionally; elseFilter wraps the new scalar.
      expect(merged, ['Xa', 'Xb']);
    });
  });

  group('mergeDataDeep', () {
    test('two maps recursively merged', () {
      final a = {
        'k': 1,
        'sub': {'x': 1, 'y': 2},
      };
      final b = {
        'sub': {'y': 20, 'z': 30},
        'extra': 99,
      };
      final merged = mergeDataDeep(a, b) as Map<dynamic, dynamic>;
      expect(merged, {
        'k': 1,
        'sub': {'x': 1, 'y': 20, 'z': 30},
        'extra': 99,
      });
    });

    test('scalar a, scalar b - b wins', () {
      expect(mergeDataDeep(1, 2), 2);
      expect(mergeDataDeep('a', 'b'), 'b');
    });

    test('scalar a, null b - null wins (no filter)', () {
      expect(mergeDataDeep(1, null), null);
    });

    test('elseFilter applied to non-iterable b', () {
      expect(mergeDataDeep(1, 'hello', (v) => 'X$v'), 'Xhello');
    });

    test('list + set dispatches to mergeListsSetsOrQueues (positional)', () {
      // List dispatches to the element-wise branch, not set-union.
      final merged = mergeDataDeep([1, 2], {3, 4}) as Iterable<dynamic>;
      expect(merged.toList(), [3, 4]);
    });

    test('set + list takes the set-union branch', () {
      final merged = mergeDataDeep({1, 2}, [3, 4]) as Iterable<dynamic>;
      expect(merged, unorderedEquals(<dynamic>[1, 2, 3, 4]));
    });

    test('iterable + iterable concatenates when not list/set/queue', () {
      // generic Iterable (not a List/Set/Queue) takes the followedBy path
      final a = Iterable<int>.generate(2, (i) => i + 1); // 1, 2
      final b = Iterable<int>.generate(2, (i) => i + 10); // 10, 11
      final merged = mergeDataDeep(a, b) as Iterable<dynamic>;
      expect(merged.toList(), [1, 2, 10, 11]);
    });

    test('does not mutate the original maps', () {
      final a = {
        'sub': {'x': 1},
      };
      final b = {
        'sub': {'y': 2},
      };
      mergeDataDeep(a, b);
      expect(a, {
        'sub': {'x': 1},
      });
      expect(b, {
        'sub': {'y': 2},
      });
    });

    test('result does NOT share mutable substructure with `a`', () {
      // Medical-grade: mutating the merged result must not silently mutate
      // the input data — that would corrupt the patient record on the fly.
      final a = <String, dynamic>{
        'aOnlyMap': <String, dynamic>{'x': 1},
        'aOnlyList': <int>[1, 2, 3],
        'both': <String, dynamic>{'inner': <int>[10]},
      };
      final b = <String, dynamic>{
        'both': <String, dynamic>{'extra': 99},
      };
      final merged = mergeDataDeep(a, b) as Map<dynamic, dynamic>;
      expect(identical(merged['aOnlyMap'], a['aOnlyMap']), isFalse);
      expect(identical(merged['aOnlyList'], a['aOnlyList']), isFalse);
      expect(identical(merged['both'], a['both']), isFalse);
      // Deep nested list from `a` also deep-copied.
      expect(
        identical(
          (merged['both'] as Map)['inner'],
          (a['both'] as Map)['inner'],
        ),
        isFalse,
      );
      // Confirm mutating result doesn't leak back into `a`.
      (merged['aOnlyMap'] as Map)['x'] = 'MUTATED';
      (merged['aOnlyList'] as List).add(999);
      expect(a['aOnlyMap'], {'x': 1});
      expect(a['aOnlyList'], [1, 2, 3]);
    });

    test('result does NOT share mutable substructure with `b`', () {
      final a = <String, dynamic>{};
      final b = <String, dynamic>{
        'nested': <String, dynamic>{'x': 99},
        'list': <int>[1, 2, 3],
      };
      final merged = mergeDataDeep(a, b) as Map<dynamic, dynamic>;
      expect(identical(merged['nested'], b['nested']), isFalse);
      expect(identical(merged['list'], b['list']), isFalse);
      // Mutating merged does not corrupt b.
      (merged['nested'] as Map)['x'] = 'MUTATED';
      (merged['list'] as List).add(999);
      expect(b['nested'], {'x': 99});
      expect(b['list'], [1, 2, 3]);
    });

    test('replacement (scalar → Map) deep-copies b', () {
      final b = <String, dynamic>{
        'x': <String, dynamic>{'inner': 1},
      };
      final merged = mergeDataDeep(1, b) as Map<dynamic, dynamic>;
      expect(identical(merged['x'], b['x']), isFalse);
      (merged['x'] as Map)['inner'] = 'MUTATED';
      expect(b['x'], {'inner': 1});
    });
  });

  group('mergeMapsDeep', () {
    test('merges a list of maps left-to-right', () {
      final merged = mergeMapsDeep<String, dynamic>([
        {
          'a': 1,
          'sub': {'x': 1},
        },
        {
          'a': 2,
          'sub': {'y': 2},
        },
        {
          'sub': {'x': 99},
        },
      ]);
      expect(merged, {
        'a': 2,
        'sub': {'x': 99, 'y': 2},
      });
    });

    test('empty list returns empty map', () {
      expect(mergeMapsDeep<String, dynamic>([]), <String, dynamic>{});
    });

    test('single map returned unchanged in structure', () {
      final merged = mergeMapsDeep<String, dynamic>([
        {'a': 1},
      ]);
      expect(merged, {'a': 1});
    });
  });

  group('tryToJson / tryToMap', () {
    test('tryToJson on object with toJson succeeds', () {
      expect(tryToJson(_ToJsonable(7)), {'x': 7});
    });

    test('tryToJson on object without toJson returns object', () {
      expect(tryToJson('plain'), 'plain');
      expect(tryToJson(42), 42);
    });

    test('tryToJson on null returns null', () {
      expect(tryToJson(null), isNull);
    });

    test('tryToJson propagates exceptions thrown BY toJson', () {
      // Medical-grade: only a missing toJson member should fall back to the
      // original object. A toJson that throws indicates a real bug and must
      // not be silently swallowed.
      final broken = _BrokenToJson();
      expect(() => tryToJson(broken), throwsStateError);
    });

    test('tryToMap on object with toMap succeeds', () {
      expect(tryToMap(_Mappable(9)), {'y': 9});
    });

    test('tryToMap on object without toMap returns object', () {
      expect(tryToMap('plain'), 'plain');
    });
  });

  group('mergeDataDeepIncludeCallsToJson', () {
    test('applies toJson when merging scalar against object', () {
      final a = {'k': 1};
      final b = {'k': _ToJsonable(5)};
      final merged = mergeDataDeepIncludeCallsToJson(a, b) as Map<dynamic, dynamic>;
      expect(merged['k'], {'x': 5});
    });
  });

  group('mergeDataDeepIncludeCallsToMap', () {
    test('applies toMap when merging scalar against object', () {
      final a = {'k': 1};
      final b = {'k': _Mappable(8)};
      final merged = mergeDataDeepIncludeCallsToMap(a, b) as Map<dynamic, dynamic>;
      expect(merged['k'], {'y': 8});
    });
  });
}
