import 'package:df_collection/df_collection.dart';
import 'package:test/test.dart';

void main() {
  group('GenericTypeOnIterableExt.genericType', () {
    test('reports T of typed list', () {
      expect(<int>[].genericType, int);
      expect(<String>[].genericType, String);
    });

    test('reports T of typed set', () {
      expect(<double>{}.genericType, double);
    });

    test('declared as Iterable<num> reports num', () {
      final Iterable<num> it = <int>[1, 2];
      expect(it.genericType, num);
    });
  });

  group('GenericTypeOnMapExt', () {
    test('key and value generic types', () {
      final m = <String, int>{};
      expect(m.genericTypeKey, String);
      expect(m.genericTypeValue, int);
    });

    test('nested generics report immediate type', () {
      final m = <String, List<int>>{};
      expect(m.genericTypeKey, String);
      expect(m.genericTypeValue, List<int>);
    });
  });
}
