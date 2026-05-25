import 'package:df_collection/df_collection.dart';
import 'package:test/test.dart';

void main() {
  group('tryMerge', () {
    test('default merge concatenates iterables', () {
      final input = <Iterable<int>?>[
        [1, 2],
        [3, 4],
      ];
      final r = input.tryMerge();
      expect(r!.toList(), [1, 2, 3, 4]);
    });

    test('skips null members via default merger', () {
      final input = <Iterable<int>?>[
        [1],
        null,
        [2],
      ];
      final r = input.tryMerge();
      expect(r!.toList(), [1, 2]);
    });

    test('returns null on empty input (reduce on empty throws)', () {
      expect(<Iterable<int>?>[].tryMerge(), isNull);
    });

    test('single element returned by reduce as-is', () {
      final input = <Iterable<int>?>[
        [1, 2, 3],
      ];
      expect(input.tryMerge()!.toList(), [1, 2, 3]);
    });

    test('custom merger', () {
      final input = <Iterable<int>?>[
        [1, 2],
        [3, 4],
        [5],
      ];
      final r = input.tryMerge(
        (a, b) => [...?a, ...?b, -1], // separator marker
      );
      expect(r!.toList(), [1, 2, 3, 4, -1, 5, -1]);
    });

    test('does NOT swallow exceptions from the merger', () {
      // Medical-grade: silently hiding a thrown error would be dangerous.
      // tryMerge only converts "no elements" into a null result.
      final input = <Iterable<int>?>[
        [1],
        [2],
      ];
      expect(
        () => input.tryMerge((_, __) => throw StateError('x')),
        throwsStateError,
      );
    });
  });
}
