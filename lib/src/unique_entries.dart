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

final _uniqueKeys = uniqueKeys;

final _uniqueValues = uniqueValues;

extension UniqueOnMapEntryIterableExtension<K, V> on Iterable<MapEntry<K, V>> {
  /// Returns only the unique entries in the iterable.
  List<MapEntry<K, V>> unique() => uniqueEntries(this);

  /// Returns only the entries with unique keys in the iterable.
  List<MapEntry<K, V>> uniqueKeys() => _uniqueKeys(this);

  /// Returns only the entries with unique values in the iterable.
  List<MapEntry<K, V>> uniqueValues() => _uniqueValues(this);
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

List<MapEntry<K, V>> uniqueEntries<K, V>(Iterable<MapEntry<K, V>> entries) {
  final uniqueKeys = <K>{};
  final uniqueValues = <V>{};
  final unique = <MapEntry<K, V>>[];

  for (var entry in entries) {
    if (!uniqueKeys.contains(entry.key) && !uniqueValues.contains(entry.value)) {
      uniqueKeys.add(entry.key);
      uniqueValues.add(entry.value);
      unique.add(MapEntry(entry.key, entry.value));
    }
  }

  return unique;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

List<MapEntry<K, V>> uniqueKeys<K, V>(Iterable<MapEntry<K, V>> entries) {
  final uniqueKeys = <K>{};
  final unique = <MapEntry<K, V>>[];

  for (var entry in entries) {
    if (!uniqueKeys.contains(entry.key)) {
      uniqueKeys.add(entry.key);
      unique.add(MapEntry(entry.key, entry.value));
    }
  }

  return unique;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

List<MapEntry<K, V>> uniqueValues<K, V>(Iterable<MapEntry<K, V>> entries) {
  final uniqueValues = <V>{};
  final unique = <MapEntry<K, V>>[];

  for (var entry in entries) {
    if (!uniqueValues.contains(entry.value)) {
      uniqueValues.add(entry.value);
      unique.add(MapEntry(entry.key, entry.value));
    }
  }

  return unique;
}
