import 'package:df_collection/df_collection.dart';
import 'package:test/test.dart';

void main() {
  group('maybeAddToIterable', () {
    test('returns null when source is null', () {
      expect(maybeAddToIterable<int>(null, [1]), isNull);
    });

    test('returns source when add is null', () {
      final src = [1, 2];
      expect(maybeAddToIterable(src, null), src);
    });

    test('concatenates both when neither null', () {
      expect(maybeAddToIterable([1, 2], [3, 4])!.toList(), [1, 2, 3, 4]);
    });
  });

  group('MaybeAddToIterableExt.maybeAdd', () {
    test('returns this when add is null', () {
      final list = [1, 2];
      expect(list.maybeAdd(null).toList(), [1, 2]);
    });

    test('returns non-nullable Iterable<T>', () {
      // Compile-time check: return type is non-nullable.
      final Iterable<int> r = <int>[1].maybeAdd([2]);
      expect(r.toList(), [1, 2]);
    });
  });

  group('maybeAddToList / MaybeAddToListExt', () {
    test('null source returns null', () {
      expect(maybeAddToList<int>(null, [1]), isNull);
    });

    test('null add returns source unchanged', () {
      final src = [1, 2];
      expect(maybeAddToList(src, null), src);
    });

    test('extension concatenates', () {
      expect([1, 2].maybeAdd([3]), [1, 2, 3]);
    });

    test('extension with null add returns this', () {
      expect([1, 2].maybeAdd(null), [1, 2]);
    });
  });

  group('maybeAddToSet / MaybeAddToSetExt', () {
    test('null source returns null', () {
      expect(maybeAddToSet<int>(null, {1}), isNull);
    });

    test('extension union-merges', () {
      expect({1, 2}.maybeAdd({2, 3}), {1, 2, 3});
    });

    test('extension with null add returns this', () {
      expect({1, 2}.maybeAdd(null), {1, 2});
    });
  });

  group('maybeAddToMap / MaybeAddToMapExt', () {
    test('null source returns null', () {
      expect(maybeAddToMap<String, int>(null, {'a': 1}), isNull);
    });

    test('extension merges with last-write-wins on key collisions', () {
      final result = {'a': 1, 'b': 2}.maybeAdd({'b': 20, 'c': 3});
      expect(result, {'a': 1, 'b': 20, 'c': 3});
    });

    test('extension with null add returns this', () {
      expect({'a': 1}.maybeAdd(null), {'a': 1});
    });
  });
}
