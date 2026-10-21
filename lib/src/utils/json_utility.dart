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

  /// Flattens [input] with [flattenJson], then adds a shortened alias key for
  /// every path suffix, as [expandFlattenedJson] does:
  /// `{'a': {'b': 1}}` becomes `{'a.b': 1, 'b': 1}`.
  ///
  /// This does **not** rebuild nested maps; for that, see [unflattenJson].
  Map<String, dynamic> expandJson(
    Map<String, dynamic> input, {
    String separator = '.',
  }) {
    return expandFlattenedJson(
      flattenJson(input, separator: separator),
      separator: separator,
    );
  }

  /// Adds a shortened alias key for every path suffix of every key in a
  /// flattened map, so a leaf can also be looked up by the tail of its path:
  /// `{'a.b.c': 1}` becomes `{'a.b.c': 1, 'b.c': 1, 'c': 1}`.
  ///
  /// The original keys are kept. An alias never replaces a key that is
  /// already present: a key in [input] always wins, and when two paths share
  /// a tail (`{'x.c': 1, 'y.c': 2}`), the alias `c` points at whichever path
  /// comes first in [input]'s iteration order.
  ///
  /// This does **not** rebuild nested maps (`{'a.b': 1}` is not turned into
  /// `{'a': {'b': 1}}`); for that, see [unflattenJson].
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

  /// Rebuilds nested maps from a flattened map, the inverse of [flattenJson]
  /// for nested maps: `{'a.b': 1, 'a.c': 2}` becomes
  /// `{'a': {'b': 1, 'c': 2}}`.
  ///
  /// Each key is split on [separator] and its value placed at that path.
  /// Lists are not rebuilt: [flattenJson]'s list indices come back as map
  /// keys (`{'list.0': 10}` becomes `{'list': {'0': 10}}`), because a map
  /// whose keys happen to be `0`, `1`, … cannot be told apart from a list.
  ///
  /// Throws [StateError] when one key is both a value and the parent of
  /// another key (`{'a': 1, 'a.b': 2}`), since keeping either would silently
  /// drop the other. Throws [ArgumentError] when [separator] is empty.
  Map<String, dynamic> unflattenJson(
    Map<String, dynamic> input, {
    String separator = '.',
  }) {
    if (separator.isEmpty) {
      throw ArgumentError.value(separator, 'separator', 'Must not be empty');
    }
    final result = <String, dynamic>{};
    // The maps this method created as parents. A leaf value that happens to
    // be a Map (e.g. an empty map from flattenJson) is not one of them, so a
    // key below it is still a collision.
    final parents = Set<Map<String, dynamic>>.identity()..add(result);
    for (final entry in input.entries) {
      final segments = entry.key.split(separator);
      var node = result;
      for (var i = 0; i < segments.length - 1; i++) {
        final segment = segments[i];
        final existing = node[segment];
        if (existing is Map<String, dynamic> && parents.contains(existing)) {
          node = existing;
          continue;
        }
        if (node.containsKey(segment)) {
          throw StateError(
            '[JsonUtility.unflattenJson] Key "${entry.key}" needs '
            '"${segments.take(i + 1).join(separator)}" to be a parent, but '
            'that key already holds a value.',
          );
        }
        final child = <String, dynamic>{};
        parents.add(child);
        node[segment] = child;
        node = child;
      }
      final leaf = segments.last;
      if (node.containsKey(leaf)) {
        throw StateError(
          '[JsonUtility.unflattenJson] Key "${entry.key}" collides with '
          'another key: "${entry.key}" is already the parent of other keys.',
        );
      }
      node[leaf] = entry.value;
    }
    return result;
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
  ///
  /// Keys become strings via [keyConverter] if given and non-null, else
  /// `DateTime` keys become their `microsecondsSinceEpoch`, else `toString()`.
  /// Throws [ArgumentError] when two keys of the same map become the same
  /// string (e.g. `{1: 'a', '1': 'b'}`), rather than silently dropping one.
  Map<String, dynamic> mapToJson<T1, T2>(
    Map<T1, T2> input, {
    Set<Type> typesAllowed = const {},
    String? Function(dynamic)? keyConverter,
  }) {
    return _mapToJson(input, typesAllowed, keyConverter)
        as Map<String, dynamic>;
  }

  dynamic _mapToJson(
    dynamic input,
    Set<Type> typesAllowed,
    String? Function(dynamic)? keyConverter,
  ) {
    if (input == null) return null;
    if (input is Map) {
      final result = <String, dynamic>{};
      for (final MapEntry(key: k, value: v) in input.entries) {
        final key =
            keyConverter?.call(k) ?? _defaultKeyConverter(k) ?? k.toString();
        if (result.containsKey(key)) {
          throw ArgumentError.value(
            input,
            'input',
            '[JsonUtility.mapToJson] Two keys convert to the same JSON key '
                '"$key" (the second is $k of type ${k.runtimeType}); one '
                'would be silently dropped.',
          );
        }
        result[key] = _mapToJson(v, typesAllowed, keyConverter);
      }
      return result;
    } else if (input is Iterable) {
      return input
          .map((e) => _mapToJson(e, typesAllowed, keyConverter))
          .toList();
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
