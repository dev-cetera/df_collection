import 'dart:collection' show Queue;

import 'package:df_collection/df_collection.dart';
import 'package:test/test.dart';

void main() {
  group('NullIfEmptyOnMapExt', () {
    test('returns null for empty map', () {
      expect(<String, int>{}.nullIfEmpty, isNull);
    });

    test('returns map itself for non-empty', () {
      final m = {'a': 1};
      expect(m.nullIfEmpty, same(m));
    });
  });

  group('NullIfEmptyOnIterableExt', () {
    test('returns null for empty iterable', () {
      expect(const Iterable<int>.empty().nullIfEmpty, isNull);
    });

    test('returns iterable itself for non-empty', () {
      final i = [1, 2];
      expect(i.nullIfEmpty, same(i));
    });
  });

  group('NullIfEmptyOnListExt', () {
    test('returns null for empty list', () {
      expect(<int>[].nullIfEmpty, isNull);
    });

    test('returns list itself for non-empty', () {
      final l = [1, 2];
      expect(l.nullIfEmpty, same(l));
    });
  });

  group('NullIfEmptyOnSetExt', () {
    test('returns null for empty set', () {
      expect(<int>{}.nullIfEmpty, isNull);
    });

    test('returns set itself for non-empty', () {
      final s = {1, 2};
      expect(s.nullIfEmpty, same(s));
    });
  });

  group('NullIfEmptyOnQueueExt', () {
    test('returns null for empty queue', () {
      expect(Queue<int>().nullIfEmpty, isNull);
    });

    test('returns queue itself for non-empty', () {
      final q = Queue<int>.of([1, 2]);
      expect(q.nullIfEmpty, same(q));
    });
  });

  group('top-level nullIfEmpty<T>', () {
    test('map: empty -> null', () {
      expect(nullIfEmpty<Map<String, int>>({}), isNull);
    });

    test('map: non-empty -> map', () {
      expect(nullIfEmpty<Map<String, int>>({'a': 1}), {'a': 1});
    });

    test('list: empty -> null', () {
      expect(nullIfEmpty<List<int>>([]), isNull);
    });

    test('list: non-empty -> list', () {
      expect(nullIfEmpty<List<int>>([1]), [1]);
    });

    test('set: empty -> null', () {
      expect(nullIfEmpty<Set<int>>(<int>{}), isNull);
    });

    test('queue: empty -> null', () {
      expect(nullIfEmpty<Queue<int>>(Queue<int>()), isNull);
    });

    test('other types pass through', () {
      expect(nullIfEmpty<int>(0), 0);
      expect(nullIfEmpty<bool>(false), false);
    });
  });
}
