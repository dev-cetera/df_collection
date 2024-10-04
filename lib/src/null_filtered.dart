//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Dart/Flutter (DF) Packages by DevCetra.com & contributors. The use of this
// source code is governed by an MIT-style license described in the LICENSE
// file located in this project's root directory.
//
// See: https://opensource.org/license/mit
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

/// Converts [input] to a Map with non-null keys and values if `K` and `V` are
/// non-null.
Map<K, V> nullFilteredMap<K, V>(Map<dynamic, dynamic> input) {
  final filtered = input.entries.toList()
    ..retainWhere(
      (e) => (null is K || e.key != null) && (null is V || e.value != null),
    );
  final mapped = filtered.map((e) => MapEntry<K, V>(e.key as K, e.value as V));
  final result = Map.fromEntries(mapped);
  return result;
}

/// Converts [input] to a List with non-null elements if `T` is non-null.
List<T> nullFilteredList<T>(Iterable<dynamic> input) {
  final filtered = input.toList()..retainWhere((e) => (null is T || e != null));
  return filtered.cast();
}

/// Converts [input] to a Set with non-null elements if `T` is non-null.
Set<T> nullFilteredSet<T>(Iterable<dynamic> input) {
  final filtered = input.toSet()..retainWhere((e) => (null is T || e != null));
  return filtered.cast();
}
