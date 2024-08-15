//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Dart/Flutter (DF) Packages by DevCetra.com & contributors. Use of this
// source code is governed by an MIT-style license that can be found in the
// LICENSE file.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

extension FirstWhereOrNullOnIterableExtension<T> on Iterable<T> {
  /// Returns the first element that satisfies the given predicate [test], or
  /// `null` if there are none.
  T? firstWhereOrNull(bool Function(T) test) {
    try {
      return firstWhere(test);
    } catch (_) {
      return null;
    }
  }
}

extension FirstWhereOrNullOnListExtension<T> on List<T> {
  /// Returns the first element that satisfies the given predicate [test], or
  /// `null` if there are none.
  T? firstWhereOrNull(bool Function(T) test) {
    try {
      return firstWhere(test);
    } catch (_) {
      return null;
    }
  }
}

extension FirstWhereOrNullOnSetExtension<T> on Set<T> {
  /// Returns the first element that satisfies the given predicate [test], or
  /// `null` if there are none.
  T? firstWhereOrNull(bool Function(T) test) {
    try {
      return firstWhere(test);
    } catch (_) {
      return null;
    }
  }
}

extension FirstWhereOrNullOnMapExtension<K, V> on Map<K, V> {
  /// Returns the first entry that satisfies the given predicate [test], or
  /// `null` if there are none.
  MapEntry<K, V>? firstWhereOrNull(bool Function(MapEntry<K, V>) test) {
    try {
      return entries.firstWhere(test);
    } catch (_) {
      return null;
    }
  }
}
