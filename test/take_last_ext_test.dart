import 'package:df_collection/df_collection.dart';
import 'package:test/test.dart';

void main() {
  group('takeLast on List', () {
    test('takes last N when N < length', () {
      expect([1, 2, 3, 4].takeLast(2).toList(), [3, 4]);
    });

    test('count == length returns full list', () {
      expect([1, 2, 3].takeLast(3).toList(), [1, 2, 3]);
    });

    test('count > length returns full list (no throw)', () {
      expect([1, 2].takeLast(99).toList(), [1, 2]);
    });

    test('count == 0 returns empty', () {
      expect([1, 2].takeLast(0).toList(), <int>[]);
    });

    test('negative count returns empty', () {
      expect([1, 2].takeLast(-5).toList(), <int>[]);
    });

    test('empty list returns empty', () {
      expect(<int>[].takeLast(3).toList(), <int>[]);
    });
  });

  group('takeLast on non-List iterables', () {
    test('streams via queue (e.g. Set)', () {
      // Sets aren't ordered as input but the queue path is exercised.
      final out = {1, 2, 3, 4, 5}.takeLast(2).toList();
      expect(out.length, 2);
    });

    test('lazy iterable count > length returns full iterable', () {
      final i = Iterable<int>.generate(3); // 0,1,2
      expect(i.takeLast(99).toList(), [0, 1, 2]);
    });

    test('lazy iterable count == 0', () {
      final i = Iterable<int>.generate(3);
      expect(i.takeLast(0).toList(), <int>[]);
    });

    test('lazy iterable count < length yields last N', () {
      final i = Iterable<int>.generate(5); // 0..4
      expect(i.takeLast(2).toList(), [3, 4]);
    });
  });
}
