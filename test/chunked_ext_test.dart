import 'package:df_collection/df_collection.dart';
import 'package:test/test.dart';

void main() {
  group('chunked', () {
    test('even split', () {
      final r = [1, 2, 3, 4].chunked(2).map((e) => e.toList()).toList();
      expect(r, [
        [1, 2],
        [3, 4],
      ]);
    });

    test('uneven split puts remainder in last chunk', () {
      final r = [1, 2, 3, 4, 5].chunked(2).map((e) => e.toList()).toList();
      expect(r, [
        [1, 2],
        [3, 4],
        [5],
      ]);
    });

    test('chunk size larger than length returns one chunk', () {
      final r = [1, 2].chunked(10).map((e) => e.toList()).toList();
      expect(r, [
        [1, 2],
      ]);
    });

    test('chunk size 1 returns singleton chunks', () {
      final r = [1, 2, 3].chunked(1).map((e) => e.toList()).toList();
      expect(r, [
        [1],
        [2],
        [3],
      ]);
    });

    test('empty input returns empty', () {
      expect(<int>[].chunked(3).toList(), isEmpty);
    });

    test('throws on chunkSize 0', () {
      expect(() => [1].chunked(0).toList(), throwsArgumentError);
    });

    test('throws on negative chunkSize', () {
      expect(() => [1].chunked(-1).toList(), throwsArgumentError);
    });

    test('top-level chunked', () {
      final r = chunked<int>([1, 2, 3], 2).map((e) => e.toList()).toList();
      expect(r, [
        [1, 2],
        [3],
      ]);
    });

    test('is lazy: only consumes as much as needed', () {
      var consumed = 0;
      Iterable<int> source() sync* {
        for (var i = 0; i < 100; i++) {
          consumed++;
          yield i;
        }
      }

      final first = source().chunked(3).first;
      expect(first.toList(), [0, 1, 2]);
      expect(consumed, 3);
    });
  });
}
