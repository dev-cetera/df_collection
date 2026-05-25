import 'package:df_collection/df_collection.dart';
import 'package:test/test.dart';

void main() {
  group('tryReduce', () {
    test('reduces a normal iterable', () {
      expect([1, 2, 3].tryReduce((a, b) => a + b), 6);
    });

    test('returns null on empty iterable', () {
      expect(<int>[].tryReduce((a, b) => a + b), isNull);
    });

    test('single element returned as-is', () {
      expect([42].tryReduce((a, b) => a + b), 42);
    });

    test('does NOT swallow exceptions from the combiner', () {
      // Medical-grade: silently hiding a thrown StateError/StackOverflowError
      // would be dangerous. tryReduce only catches the "no element" case.
      expect(
        () => [1, 2].tryReduce((_, __) => throw StateError('x')),
        throwsStateError,
      );
    });
  });
}
