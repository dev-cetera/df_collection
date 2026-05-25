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

/// Safely retrieves and converts a value from a nested data structure using a
/// dot-separated [path].
///
/// This is a convenience wrapper around [deepGetFromSegments].
dynamic deepGet(
  Map<dynamic, dynamic>? map,
  String path, {
  String separator = '.',
}) {
  return deepGetFromSegments(map, path.split(separator));
}

/// Safely retrieves and converts a value from a nested data structure using a
/// list of path [pathSegments].
///
/// This is the core utility that can traverse both [Map] and [Iterable].
///
/// It intelligently handles path segments:
/// - If a segment is a [num], it's used as a list index as an [int].
/// - If a segment is a [String] that can be parsed as a [num] AND the current
///   value is [Iterable], it's used as an index.
/// - Otherwise, the segment is used as a [Map] key.
///
/// {@tool snippet}
/// ```dart
/// final data = {
///   'users': [
///     {'name': 'Alice'},
///     {'name': 'Bob', 'roles': {'editor': true}}
///   ],
///   '2': 'A numeric string key'
/// };
///
/// // Access list by integer index in a string path.
/// final bobsName = deepGet<String>(data, 'users.1.name');
/// print(bobsName); // Prints: Bob
///
/// // Access map by a numeric string key.
/// final numericKeyVal = deepGetFromSegments(data, ['2']);
/// print(numericKeyVal); // Prints: "A numeric string key"
/// ```
/// {@end-tool}
dynamic deepGetFromSegments(
  Map<dynamic, dynamic>? map,
  Iterable<dynamic> pathSegments,
) {
  if (map == null) return null;
  dynamic current = map;
  for (final segment in pathSegments) {
    if (current == null) {
      return null;
    }
    if (current is List) {
      final index = _asIntIndex(segment);
      if (index == null || index < 0 || index >= current.length) {
        return null;
      }
      current = current[index];
    } else if (current is Iterable) {
      // Non-List iterables (notably `Set`) have implementation-defined
      // element order, so numeric indexing into them would be
      // non-deterministic. For medical-grade safety we refuse to traverse
      // them positionally — callers should convert to a List first if they
      // really mean "the nth element".
      return null;
    } else if (current is Map) {
      current = current[segment];
    } else {
      return null;
    }
  }
  return current;
}

/// Returns [segment] as a non-negative int index, or `null` if it does not
/// represent an exact integer in `[0, 2^53)`. Doubles such as `3.5` and
/// strings like `"3.5"` are rejected (they would otherwise truncate
/// silently); strings such as `"3"` and ints are accepted.
int? _asIntIndex(dynamic segment) {
  if (segment is int) return segment;
  if (segment is double) {
    if (!segment.isFinite || segment != segment.truncateToDouble()) return null;
    return segment.toInt();
  }
  if (segment is String) {
    return int.tryParse(segment);
  }
  return null;
}
