import 'package:df_collection/df_collection.dart';
import 'package:test/test.dart';

void main() {
  group('CsvUtility.mapToCsv', () {
    test('basic key/value pairs', () {
      final csv = CsvUtility.i.mapToCsv({'a': 1, 'b': 2});
      expect(csv.trim().split('\n'), ['a,1', 'b,2']);
    });

    test('quotes values containing commas', () {
      final csv = CsvUtility.i.mapToCsv({'k': 'a,b'});
      expect(csv.trim(), 'k,"a,b"');
    });

    test('escapes embedded quotes', () {
      final csv = CsvUtility.i.mapToCsv({'k': 'a"b'});
      expect(csv.trim(), 'k,"a""b"');
    });

    test('quotes values containing newlines', () {
      final csv = CsvUtility.i.mapToCsv({'k': 'line1\nline2'});
      expect(csv.trim(), 'k,"line1\nline2"');
    });

    test('quotes keys with special characters too', () {
      final csv = CsvUtility.i.mapToCsv({'a,b': 1});
      expect(csv.trim(), '"a,b",1');
    });

    test('empty map returns empty string', () {
      expect(CsvUtility.i.mapToCsv(<dynamic, dynamic>{}), '');
    });

    test('handles non-string values via toString', () {
      final csv = CsvUtility.i.mapToCsv({'k': true, 'n': null});
      expect(csv.trim().split('\n'), ['k,true', 'n,null']);
    });
  });

  group('CsvUtility.csvToMap', () {
    test('parses simple rows', () {
      final result = CsvUtility.i.csvToMap('a,1\nb,2');
      expect(result, {
        0: ['a', '1'],
        1: ['b', '2'],
      });
    });

    test('parses quoted values containing commas', () {
      final result = CsvUtility.i.csvToMap('k,"a,b"');
      expect(result[0], ['k', 'a,b']);
    });

    test('parses unescaped doubled quotes', () {
      final result = CsvUtility.i.csvToMap('k,"a""b"');
      expect(result[0], ['k', 'a"b']);
    });

    test('preserves blank lines as empty rows (no silent renumbering)', () {
      final result = CsvUtility.i.csvToMap('a,1\n\nb,2\n');
      // a,1 at 0, empty row at 1, b,2 at 2. Row 2 is NOT silently renumbered
      // to 1 — this matters for medical-grade workflows that key on the
      // original row position.
      expect(result.length, 3);
      expect(result[0], ['a', '1']);
      expect(result[1], ['']);
      expect(result[2], ['b', '2']);
    });

    test('empty input returns empty map', () {
      expect(CsvUtility.i.csvToMap(''), <int, List<String>>{});
    });

    test('handles CRLF line terminators', () {
      final result = CsvUtility.i.csvToMap('a,1\r\nb,2\r\n');
      expect(result.length, 2);
      expect(result[0], ['a', '1']);
      expect(result[1], ['b', '2']);
    });

    test('handles bare CR line terminators', () {
      final result = CsvUtility.i.csvToMap('a,1\rb,2');
      expect(result.length, 2);
      expect(result[0], ['a', '1']);
      expect(result[1], ['b', '2']);
    });

    test('preserves newline inside quoted field', () {
      final result = CsvUtility.i.csvToMap('a,"line1\nline2"\n');
      expect(result.length, 1);
      expect(result[0], ['a', 'line1\nline2']);
    });

    test('preserves significant leading/trailing whitespace inside quotes', () {
      final result = CsvUtility.i.csvToMap('"  hello  ",foo\n');
      expect(result[0], ['  hello  ', 'foo']);
    });

    test('does not strip whitespace outside quotes either', () {
      // Whitespace outside quotes is treated as literal data: a CSV parser
      // that strips it can corrupt readings (e.g. " 12.5 " becoming "12.5"
      // could mask a numeric-parser bug downstream).
      final result = CsvUtility.i.csvToMap(' a , 1 ');
      expect(result[0], [' a ', ' 1 ']);
    });

    test('handles embedded escaped quotes inside a long quoted field', () {
      final result = CsvUtility.i.csvToMap('"He said ""hi"" twice","next"\n');
      expect(result[0], ['He said "hi" twice', 'next']);
    });

    test('round-trips multiline quoted field through mapToCsv/csvToMap', () {
      final original = {'note': 'line1\nline2\nline3'};
      final csv = CsvUtility.i.mapToCsv(original);
      final parsed = CsvUtility.i.csvToMap(csv);
      expect(parsed[0], ['note', 'line1\nline2\nline3']);
    });
  });

  group('CsvUtility round-trip', () {
    test('mapToCsv -> csvToMap preserves values', () {
      final original = {'name': 'Alice, the great', 'quote': 'She said "hi"'};
      final csv = CsvUtility.i.mapToCsv(original);
      final parsed = CsvUtility.i.csvToMap(csv);
      final rebuilt = <String, String>{};
      for (final row in parsed.values) {
        rebuilt[row[0]] = row[1];
      }
      expect(rebuilt, original);
    });
  });
}
