import 'package:df_collection/df_collection.dart';
import 'package:test/test.dart';

void main() {
  group('combinedOrderedStringId', () {
    test('orders alphabetically and joins with underscore', () {
      expect(combinedOrderedStringId(['c', 'a', 'b']), 'a_b_c');
    });

    test('different input orders produce same ID', () {
      expect(
        combinedOrderedStringId(['x', 'y', 'z']),
        combinedOrderedStringId(['z', 'y', 'x']),
      );
    });

    test('single ID returns itself', () {
      expect(combinedOrderedStringId(['only']), 'only');
    });

    test('empty list returns empty string', () {
      expect(combinedOrderedStringId(<String>[]), '');
    });

    test('throws when any ID is empty (medical-grade: no ambiguous IDs)', () {
      expect(
        () => combinedOrderedStringId(['', 'a']),
        throwsArgumentError,
      );
      expect(
        () => combinedOrderedStringId(['']),
        throwsArgumentError,
      );
    });

    test('throws when separator is empty (would erase boundaries)', () {
      expect(
        () => combinedOrderedStringId(['a', 'b'], separator: ''),
        throwsArgumentError,
      );
    });

    test('does not mutate input', () {
      final input = ['c', 'a', 'b'];
      combinedOrderedStringId(input);
      expect(input, ['c', 'a', 'b']);
    });

    test('handles duplicates by keeping them', () {
      expect(combinedOrderedStringId(['a', 'a', 'b']), 'a_a_b');
    });

    test('throws if any ID contains the separator (no silent collision)', () {
      expect(
        () => combinedOrderedStringId(['a_b', 'c']),
        throwsArgumentError,
      );
    });

    test('respects custom separator', () {
      expect(
        combinedOrderedStringId(['b', 'a', 'c'], separator: '|'),
        'a|b|c',
      );
    });

    test('throws if any ID contains the custom separator', () {
      expect(
        () => combinedOrderedStringId(['a|b', 'c'], separator: '|'),
        throwsArgumentError,
      );
    });
  });
}
