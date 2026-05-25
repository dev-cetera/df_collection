import 'package:df_collection/df_collection.dart';
import 'package:test/test.dart';

void main() {
  group('cartesianProduct', () {
    test('two sets', () {
      final r = [
        {1, 2},
        {10, 20},
      ].cartesianProduct((a, b) => a + b);
      expect(r.toList(), unorderedEquals(<int>[11, 21, 12, 22]));
    });

    test('three sets', () {
      final r = [
        {1, 2},
        {10},
        {100, 200},
      ].cartesianProduct((a, b) => a + b);
      // (1+10)=11, (2+10)=12; with {100,200}: 111,211,112,212
      expect(r.toList(), unorderedEquals(<int>[111, 211, 112, 212]));
    });

    test('single set returned as-is', () {
      final r = [
        {1, 2, 3},
      ].cartesianProduct((a, b) => a + b);
      expect(r.toList(), unorderedEquals(<int>[1, 2, 3]));
    });

    test('empty top-level returns empty', () {
      final r = <Set<int>>[].cartesianProduct((a, b) => a + b);
      expect(r, isEmpty);
    });

    test('one empty set is filtered out', () {
      final r = [
        {1, 2},
        <int>{}, // empty
        {10, 20},
      ].cartesianProduct((a, b) => a + b);
      expect(r.toList(), unorderedEquals(<int>[11, 21, 12, 22]));
    });

    test('all empty sets returns empty', () {
      final r = [
        <int>{},
        <int>{},
      ].cartesianProduct((a, b) => a + b);
      expect(r, isEmpty);
    });

    test('strings with concatenation', () {
      final r = [
        ['a', 'b'],
        ['1', '2'],
      ].cartesianProduct((a, b) => a + b);
      expect(r.toList(), ['a1', 'a2', 'b1', 'b2']);
    });

    test('top-level function form', () {
      final r = cartesianProduct<int>(
        [
          {1, 2},
          {10, 20},
        ],
        (a, b) => a + b,
      );
      expect(r.toList(), unorderedEquals(<int>[11, 21, 12, 22]));
    });
  });
}
