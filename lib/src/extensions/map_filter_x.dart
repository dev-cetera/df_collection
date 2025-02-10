//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Dart/Flutter (DF) Packages by dev-cetera.com & contributors. The use of this
// source code is governed by an MIT-style license described in the LICENSE
// file located in this project's root directory.
//
// See: https://opensource.org/license/mit
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

extension MapWithDefaultOnMapX<K, V> on Map<K, V> {
  /// Returns a new map with the same keys as this map but with the specified
  /// [defaultValue] for all values that are null. If [defaultValue] is null,
  /// it simply returns a copy of the original map.
  Map<K, dynamic> mapWithDefault(dynamic defaultValue) {
    return defaultValue != null
        ? map((k, v) => MapEntry(k, v ?? defaultValue))
        : Map.of(this);
  }

  /// Filters the map's entries based on a list of included values.
  /// Returns a new map containing only the key-value pairs where the value
  /// is found within the [includedValues].
  Map<K, V> filterByIncludedValues(List<V> includedValues) {
    return Map.fromEntries(
      entries.where((e) => includedValues.contains(e.value)),
    );
  }

  /// Filters the map's entries based on a list of excluded values.
  /// Returns a new map excluding the key-value pairs where the value
  /// is found within the [excludedValues].
  Map<K, V> filterByExcludedValues(List<V> excludedValues) {
    return Map.fromEntries(
      entries.where((e) => !excludedValues.contains(e.value)),
    );
  }

  /// Filters the map's entries based on a list of included keys.
  /// Returns a new map containing only the key-value pairs where the key
  /// is found within the [includedKeys].
  Map<K, V> filterByIncludedKeys(List<K> includedKeys) {
    return Map.fromEntries(
      entries.where((e) => includedKeys.contains(e.key)),
    );
  }

  /// Filters the map's entries based on a list of excluded keys.
  /// Returns a new map excluding the key-value pairs where the key
  /// is found within the [excludedKeys].
  Map<K, V> filterByExcludedKeys(List<K> excludedKeys) {
    return Map.fromEntries(
      entries.where((e) => !excludedKeys.contains(e.key)),
    );
  }
}
