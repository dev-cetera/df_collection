//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Copyright © dev-cetera.com & contributors.
//
// The use of this source code is governed by an MIT-style license described in
// the LICENSE file located in this project's root directory.
//
// See: https://opensource.org/license/mit
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

final class CsvUtility {
  const CsvUtility._();
  static final i = const CsvUtility._();

  /// Escapes a single field for CSV formatting (RFC 4180 conformant: a field
  /// is quoted when it contains the delimiter, a quote, CR or LF).
  String _escape(dynamic field) {
    final value = field.toString();
    if (value.contains(',') ||
        value.contains('"') ||
        value.contains('\n') ||
        value.contains('\r')) {
      final escaped = value.replaceAll('"', '""');
      return '"$escaped"';
    }
    return value;
  }

  String mapToCsv(Map<dynamic, dynamic> input) {
    final buffer = StringBuffer();
    for (final entry in input.entries) {
      final key = _escape(entry.key);
      final value = _escape(entry.value);
      buffer.writeln('$key,$value');
    }
    return buffer.toString();
  }

  /// Parses CSV text into a row-indexed map. The parser is RFC 4180
  /// compliant: it preserves fields exactly (no whitespace trimming),
  /// supports both `\n` and `\r\n` line terminators, supports quoted
  /// fields that contain commas, quotes (escaped as `""`) and newlines,
  /// and does NOT silently renumber rows when the input contains blank
  /// lines — blank lines are preserved as empty rows so row indices match
  /// the source.
  Map<int, List<String>> csvToMap(String input) {
    final rows = <List<String>>[];
    var field = StringBuffer();
    var row = <String>[];
    var inQuotes = false;
    var i = 0;
    final n = input.length;
    while (i < n) {
      final ch = input[i];
      if (inQuotes) {
        if (ch == '"') {
          if (i + 1 < n && input[i + 1] == '"') {
            // Escaped quote inside a quoted field.
            field.write('"');
            i += 2;
            continue;
          }
          inQuotes = false;
          i++;
          continue;
        }
        field.write(ch);
        i++;
        continue;
      }
      if (ch == '"') {
        inQuotes = true;
        i++;
        continue;
      }
      if (ch == ',') {
        row.add(field.toString());
        field = StringBuffer();
        i++;
        continue;
      }
      if (ch == '\r') {
        // Consume CR (and an optional following LF) as a row terminator.
        row.add(field.toString());
        rows.add(row);
        field = StringBuffer();
        row = <String>[];
        if (i + 1 < n && input[i + 1] == '\n') {
          i += 2;
        } else {
          i++;
        }
        continue;
      }
      if (ch == '\n') {
        row.add(field.toString());
        rows.add(row);
        field = StringBuffer();
        row = <String>[];
        i++;
        continue;
      }
      field.write(ch);
      i++;
    }
    // Flush the final field/row if input did not end with a line terminator.
    // If the input ended cleanly with a terminator and there's no pending
    // content, we don't emit a phantom trailing empty row.
    if (field.isNotEmpty || row.isNotEmpty) {
      row.add(field.toString());
      rows.add(row);
    }
    final res = <int, List<String>>{};
    for (var r = 0; r < rows.length; r++) {
      res[r] = rows[r];
    }
    return res;
  }
}
