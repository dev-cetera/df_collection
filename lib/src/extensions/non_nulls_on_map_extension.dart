//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Dart/Flutter (DF) Packages by DevCetra.com & contributors. Use of this
// source code is governed by an MIT-style license that can be found in the
// LICENSE file.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

extension NonNullsOnMapExtension<K, V> on Map<K?, V?> {
  /// Returns a new map with all non-null keys and values.
  Map<K, V> get nonNulls {
    return Map<K, V>.fromEntries(
      entries
          .where((e) => e.key != null && e.value != null)
          .map((e) => MapEntry(e.key as K, e.value as V)),
    );
  }
}

extension NonNullKeysOnMapExtension<K, V> on Map<K?, V> {
  /// Returns a new map with all non-null keys and values.
  Map<K, V> get nonNullKeys {
    return Map<K, V>.fromEntries(
      entries.where((e) => e.key != null).map((e) => MapEntry(e.key as K, e.value)),
    );
  }
}

extension NonNullValuesOnMapExtension<K, V> on Map<K, V?> {
  /// Returns a new map with all non-null keys and values.
  Map<K, V> get nonNullValues {
    return Map<K, V>.fromEntries(
      entries.where((e) => e.value != null).map((e) => MapEntry(e.key, e.value as V)),
    );
  }
}
