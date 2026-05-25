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
      void put(String path, dynamic value) {
        // Detect silent collisions where two different source paths map to
        // the same flat key — this would be a data-loss bug for any caller.
        if (result.containsKey(path)) {
          throw StateError(
            '[JsonUtility.flattenJson] Path collision at "$path". Two distinct '
            'source paths produced the same flat key. This usually means a '
            'key in the input contains the separator "$separator", or a '
            'nested structure conflicts with a literal dotted key.',
          );
        }
        result[path] = value;
      }

      void flatten(String path, dynamic value) {
        if (value is Map) {
          if (value.isEmpty) {
            if (path.isNotEmpty) put(path, value);
            return;
          }
          for (final entry in value.entries) {
            final k = entry.key;
            final v = entry.value;
            final keyStr = k.toString();
            if (keyStr.contains(separator)) {
              throw StateError(
                '[JsonUtility.flattenJson] Source key "$keyStr" contains the '
                'separator "$separator"; flattening would produce an '
                'ambiguous path. Pick a separator that does not appear in '
                'any key.',
              );
            }
            final newPath = path.isEmpty ? keyStr : '$path$separator$keyStr';
            flatten(newPath, v);
          }
        } else if (value is List) {
          if (value.isEmpty) {
            if (path.isNotEmpty) put(path, value);
            return;
          }
          for (var i = 0; i < value.length; i++) {
            final newPath = path.isEmpty ? '$i' : '$path$separator$i';
            flatten(newPath, value[i]);
          }
        } else {
          put(path, value);
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
    if (input == null) return null;
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
    // Reject NaN/Infinity — these are not representable in standard JSON
    // (`dart:convert.jsonEncode` would fail) and silently passing them
    // through is a data-integrity hazard.
    if (input is double && !input.isFinite) {
      throw UnsupportedError(
        '[JsonUtility.mapToJson] Non-finite double ($input) cannot be '
        'represented in standard JSON.',
      );
    }
    if (input is bool || input is num || input is String) {
      return input;
    }
    if (typesAllowed.contains(input.runtimeType)) {
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
