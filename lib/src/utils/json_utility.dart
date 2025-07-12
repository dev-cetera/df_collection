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

final class JsonUtility {
  const JsonUtility._();
  static final i = const JsonUtility._();

  /// Expands a Json map, e.g. `{'a': {'b': 1}}` to `{a.b: 1, b: 1}`.
  Map<String, dynamic> expandJson(
    Map<String, dynamic> input, {
    String separator = '.',
  }) {
    return expandFlattenedJson(
      flattenJson(input, separator: separator),
      separator: separator,
    );
  }

  /// Expands a flattened JSON map, e.g. `{'a.b': 1}` to `{a.b: 1, b: 1}`.
  Map<String, dynamic> expandFlattenedJson(
    Map<String, dynamic> input, {
    String separator = '.',
  }) {
    final res = {...input};
    var modified = true;
    while (modified) {
      final currentRes = {...res};
      modified = false;
      for (final entry in currentRes.entries) {
        final key = entry.key;
        final value = entry.value;
        final parts = key.split(separator);
        if (parts.length > 1) {
          final modifiedKey = parts.sublist(1).join(separator);
          if (!res.containsKey(modifiedKey)) {
            res[modifiedKey] = value;
            modified = true;
          }
        }
      }
    }

    return res;
  }

  /// Flattens a nested JSON object into a single-level map with string keys.
  ///
  ///
  /// The function can handle nested structures containing other Maps and
  /// Lists. In the case of Lists, the list indices are included in the
  /// flattened keys.
  ///
  /// ### Parameters:
  ///
  /// - [input] The nested Map to be flattened. This map can contain other
  ///   maps, lists, and basic data types (e.g., String, int, bool).
  /// - [separator] A string used to separate the segments of the path
  ///   in the keys of the resulting flat map. Defaults to `.`.
  ///
  /// ### Returns:
  ///
  /// A Map where each key is a path composed of the keys from the original
  /// nested map (and indices for lists), separated by [separator], leading to
  /// the corresponding value.
  ///
  /// ### Example Usage:
  /// ```dart
  /// final nestedJson = {
  ///   'user': {
  ///     'name': 'Phillip Sherman',
  ///     'address': {
  ///       'street': '42 Wallaby Way',
  ///       'city': 'Sydney',
  ///       'zip': '2000'
  ///     }
  ///   },
  ///   'emails': [
  ///     'p.sherman@sydneydental.com.au',
  ///     'phillip.sherman@gmail.com'
  ///   ]
  /// };
  ///
  /// final flattened = flattenJson(nestedJson);
  /// print(flattened);
  /// // Output:
  /// // {
  /// //   'user.name': 'hillip Sherman',
  /// //   'user.address.street': '42 Wallaby Way',
  /// //   'user.address.city': 'Sydney',
  /// //   'user.address.zip': '2000',
  /// //   'emails.0': 'p.sherman@sydneydental.com.au',
  /// //   'emails.1': 'phillip.sherman@gmail.com'
  /// // }
  /// ```
  Map<String, dynamic> flattenJson(
    Map<String, dynamic> input, {
    String separator = '.',
  }) {
    Map<String, dynamic> $flattenJson(dynamic input, [String prefix = '']) {
      final result = <String, dynamic>{};
      void flatten(String path, dynamic value) {
        if (value is Map) {
          for (final entry in value.entries) {
            final k = entry.key;
            final v = entry.value;
            final newPath = path.isEmpty ? k.toString() : '$path$separator$k';
            flatten(newPath, v);
          }
        } else if (value is List) {
          for (var i = 0; i < value.length; i++) {
            flatten('$path$separator$i', value[i]);
          }
        } else {
          result[path] = value;
        }
      }

      flatten(prefix, input);
      return result;
    }

    return $flattenJson(input);
  }

  /// Converts a map to a Json map by recursively converting its keys and values
  /// to Json compatible types.
  Map<String, dynamic> mapToJson<T1, T2>(
    Map<T1, T2> input, {
    Set<Type> typesAllowed = const {},
    String? Function(dynamic)? keyConverter,
  }) {
    return _mapToJson(input, typesAllowed, keyConverter) as Map<String, dynamic>;
  }

  dynamic _mapToJson(
    dynamic input,
    Set<Type> typesAllowed,
    String? Function(dynamic)? keyConverter,
  ) {
    if (input is Map) {
      return input.map(
        (k, v) => MapEntry(
          keyConverter?.call(k) ?? _defaultKeyConverter(k) ?? k.toString(),
          _mapToJson(v, typesAllowed, keyConverter),
        ),
      );
    } else if (input is Iterable) {
      return input.map((e) => _mapToJson(e, typesAllowed, keyConverter)).toList();
    }
    if ({
      bool,
      String,
      int,
      double,
      num,
      ...typesAllowed,
    }.contains(input.runtimeType)) {
      return input;
    }
    throw UnsupportedError(
      '[JsonUtility.mapToJson] Unsupported type "${input.runtimeType}" found.',
    );
  }

  String? _defaultKeyConverter(dynamic key) {
    if (key is DateTime) {
      return key.microsecondsSinceEpoch.toString();
    }
    return null;
  }
}
