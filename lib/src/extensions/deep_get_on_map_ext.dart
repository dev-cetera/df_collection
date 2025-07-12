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

import '/src/utils/deep_get.dart' as deep_get show deepGet, deepGetFromSegments;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

extension DeepGetOnMapExt on Map<dynamic, dynamic> {
  /// Safely retrieves and converts a value from a nested data structure using a
  /// dot-separated [path].
  ///
  /// This is a convenience wrapper around [deepGetFromSegments].
  dynamic deepGet(String path, {String separator = '.'}) {
    return deep_get.deepGet(this, path, separator: separator);
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
  /// final bobsName = data.deepGet<String>('users.1.name');
  /// print(bobsName); // Prints: Bob
  ///
  /// // Access map by a numeric string key.
  /// final numericKeyVal = data.deepGetFromSegments(['2']);
  /// print(numericKeyVal); // Prints: "A numeric string key"
  /// ```
  /// {@end-tool}
  dynamic deepGetFromSegments(Iterable<dynamic> pathSegments) {
    return deep_get.deepGetFromSegments(this, pathSegments);
  }
}
