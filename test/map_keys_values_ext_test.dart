import 'package:df_collection/df_collection.dart';
import 'package:test/test.dart';

void main() {
  group('mapKeys', () {
    test('transforms keys, keeps values', () {
      final result = {'a': 1, 'b': 2}.mapKeys((k) => k.toUpperCase());
      expect(result, {'A': 1, 'B': 2});
    });

    test('changes key type', () {
      final result = {'1': 10, '2': 20}.mapKeys<int>(int.parse);
      expect(result, {1: 10, 2: 20});
    });

    test('empty map', () {
      expect(<String, int>{}.mapKeys((k) => k.length), <int, int>{});
    });

    test('collisions cause last write wins', () {
      final result = {'a': 1, 'b': 2}.mapKeys((_) => 'same');
      expect(result, {'same': 2});
    });
  });

  group('mapValues', () {
    test('transforms values, keeps keys', () {
      final result = {'a': 1, 'b': 2}.mapValues((v) => v * 10);
      expect(result, {'a': 10, 'b': 20});
    });

    test('changes value type', () {
      final result = {'a': 1, 'b': 2}.mapValues<String>((v) => 'v$v');
      expect(result, {'a': 'v1', 'b': 'v2'});
    });

    test('empty map', () {
      expect(<String, int>{}.mapValues((v) => v + 1), <String, int>{});
    });
  });
}
