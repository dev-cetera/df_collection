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

extension ToMapOnIterableExtension<K, V> on Iterable<MapEntry<K, V>> {
  /// Converts an iterable of [MapEntry] to a [Map].
  Map<K, V> toMap() {
    return Map.fromEntries(this);
  }
}

/// Returns the difference between two sets.
Set<T> getSetDifference<T>(Set<T> before, Set<T> after) {
  final results = <T>{};
  for (final a in after) {
    if (!before.contains(a)) results.add(a);
  }
  return results;
}

extension TryReduceOnIterableExtension<T> on Iterable<T> {
  /// Tries to reduce the iterable, returning null if it fails.
  T? tryReduce(T Function(T, T) combine) {
    try {
      return reduce(combine);
    } catch (_) {
      return null;
    }
  }
}

extension TryMergeOnIterableExtension<T> on Iterable<Iterable<T>?> {
  /// Tries to merge the iterables, returning null if it fails.
  Iterable<T>? tryMerge([
    Iterable<T> Function(Iterable<T>?, Iterable<T>?)? merge,
  ]) {
    try {
      return reduce(merge ?? (a, b) => <T>[...a ?? [], ...b ?? []]);
    } catch (_) {
      return null;
    }
  }
}

/// Generates an ordered ID from a list of unordered IDs, that can be
/// used to identify the list of IDs.
///
/// For example, this can be used to combine user IDs into a single ID that
/// represents the group of users.
String combinedOrderedStringId(List<String> ids) {
  final sorted = ids..sort((a, b) => a.compareTo(b));
  final combined = sorted.join('_');
  return combined;
}

extension TakeLastOnIterableExtension on Iterable<String> {
  /// Takes the last [count] elements from the iterable.
  Iterable<String> takeLast(int count) {
    return toList().reversed.take(count).toList().reversed;
  }
}
