import 'package:df_collection/df_collection.dart';
import 'package:test/test.dart';

void main() {
  group('joinWithLastSeparator', () {
    test('empty', () {
      expect(<String>[].joinWithLastSeparator(), '');
    });

    test('single element', () {
      expect(['a'].joinWithLastSeparator(), 'a');
    });

    test('two elements use last separator', () {
      expect(['a', 'b'].joinWithLastSeparator(), 'a & b');
    });

    test('three elements mix separators', () {
      expect(['a', 'b', 'c'].joinWithLastSeparator(), 'a, b & c');
    });

    test('four+ elements use list separator until last two', () {
      expect(
        ['a', 'b', 'c', 'd'].joinWithLastSeparator(),
        'a, b, c & d',
      );
    });

    test('custom separators', () {
      expect(
        ['a', 'b', 'c'].joinWithLastSeparator(separator: '; ', lastSeparator: ' and '),
        'a; b and c',
      );
    });

    test('converts non-string elements via toString', () {
      expect([1, 2, 3].joinWithLastSeparator(), '1, 2 & 3');
    });

    test('single null element prints "null"', () {
      expect([null].joinWithLastSeparator(), 'null');
    });
  });
}
