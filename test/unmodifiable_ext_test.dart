import 'package:df_collection/df_collection.dart';
import 'package:test/test.dart';

void main() {
  group('UnmodifiableOnMapExt', () {
    test('returns equal contents', () {
      expect({'a': 1, 'b': 2}.unmodifiable, {'a': 1, 'b': 2});
    });

    test('throws on mutation', () {
      final m = {'a': 1}.unmodifiable;
      expect(() => m['b'] = 2, throwsUnsupportedError);
    });

    test('throws on removal', () {
      final m = {'a': 1}.unmodifiable;
      expect(() => m.remove('a'), throwsUnsupportedError);
    });
  });

  group('UnmodifiableOnListExt', () {
    test('contents preserved', () {
      expect([1, 2, 3].unmodifiable, [1, 2, 3]);
    });

    test('throws on add', () {
      final l = [1].unmodifiable;
      expect(() => l.add(2), throwsUnsupportedError);
    });

    test('throws on index assignment', () {
      final l = [1].unmodifiable;
      expect(() => l[0] = 99, throwsUnsupportedError);
    });
  });

  group('UnmodifiableOnSetExt', () {
    test('contents preserved', () {
      expect({1, 2, 3}.unmodifiable, {1, 2, 3});
    });

    test('throws on add', () {
      final s = {1}.unmodifiable;
      expect(() => s.add(2), throwsUnsupportedError);
    });

    test('throws on remove', () {
      final s = {1}.unmodifiable;
      expect(() => s.remove(1), throwsUnsupportedError);
    });
  });
}
