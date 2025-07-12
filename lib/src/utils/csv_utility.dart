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

  /// Escapes a single field for CSV formatting.
  String _escape(dynamic field) {
    final value = field.toString();
    // If the value contains a comma, quote, or newline, it must be quoted.
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
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

  Map<int, List<String>> csvToMap(String input) {
    final regex = RegExp(r',(?=(?:[^"]*"[^"]*")*[^"]*$)');
    final lines = input.split('\n').where((line) => line.isNotEmpty).toList();
    final res = <int, List<String>>{};

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final parts = line.split(regex).map((part) {
        var trimmed = part.trim();
        if (trimmed.length >= 2 && trimmed.startsWith('"') && trimmed.endsWith('"')) {
          trimmed = trimmed.substring(1, trimmed.length - 1);
          return trimmed.replaceAll('""', '"');
        }
        return trimmed;
      }).toList();
      res[i] = parts;
    }
    return res;
  }
}
