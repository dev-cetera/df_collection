import 'package:df_collection/df_collection.dart';
import 'package:test/test.dart';

void main() {
  group('unique (no equals)', () {
    test('removes consecutive duplicates', () {
      expect([1, 1, 2, 2, 3].unique().toList(), [1, 2, 3]);
    });

    test('removes non-consecutive duplicates preserving order', () {
      expect([3, 1, 2, 1, 3].unique().toList(), [3, 1, 2]);
    });

    test('empty input', () {
      expect(<int>[].unique().toList(), <int>[]);
    });

    test('all duplicates', () {
      expect([1, 1, 1].unique().toList(), [1]);
    });

    test('all unique', () {
      expect([1, 2, 3].unique().toList(), [1, 2, 3]);
    });
  });

  group('unique with equals', () {
    test('uses custom equality (case-insensitive)', () {
      final r = ['A', 'a', 'B', 'b']
          .unique((x, y) => x.toLowerCase() == y.toLowerCase())
          .toList();
      expect(r, ['A', 'B']);
    });

    test('always-equal eq collapses to first', () {
      expect([1, 2, 3].unique((_, __) => true).toList(), [1]);
    });

    test('never-equal eq keeps everything', () {
      expect([1, 1, 1].unique((_, __) => false).toList(), [1, 1, 1]);
    });
  });

  group('top-level unique', () {
    test('default equality', () {
      expect(unique<int>([1, 2, 1]).toList(), [1, 2]);
    });
  });
}
