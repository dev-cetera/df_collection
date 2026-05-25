import 'package:df_collection/df_collection.dart';
import 'package:test/test.dart';

void main() {
  group('getSetDifference', () {
    test('returns elements only in after', () {
      expect(getSetDifference({1, 2, 3}, {2, 3, 4}), {4});
    });

    test('empty when after is subset of before', () {
      expect(getSetDifference({1, 2, 3}, {1, 2}), <int>{});
    });

    test('returns all after if before is empty', () {
      expect(getSetDifference(<int>{}, {1, 2, 3}), {1, 2, 3});
    });

    test('empty when both are empty', () {
      expect(getSetDifference(<int>{}, <int>{}), <int>{});
    });

    test('does not mutate inputs', () {
      final before = {1, 2};
      final after = {2, 3};
      getSetDifference(before, after);
      expect(before, {1, 2});
      expect(after, {2, 3});
    });

    test('works with strings', () {
      expect(
        getSetDifference({'a', 'b'}, {'b', 'c', 'd'}),
        {'c', 'd'},
      );
    });
  });
}
