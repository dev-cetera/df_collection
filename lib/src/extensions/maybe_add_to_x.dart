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

/// Adds [add] to [source] if both are not null.
Iterable<T>? maybeAddToIterable<T>(Iterable<T>? source, Iterable<T>? add) {
  if (source == null) return source;
  if (add == null) return source;
  return [...source, ...add];
}

extension MaybeAddToIterableX<T> on Iterable<T> {
  /// Adds [add] to this its not null.
  Iterable<T>? maybeAdd(Iterable<T>? add) => maybeAddToIterable(this, add)!;
}

/// Adds [add] to [source] if both are not null.
List<T>? maybeAddToList<T>(List<T>? source, List<T>? add) {
  if (source == null) return source;
  if (add == null) return source;
  return [...source, ...add];
}

extension MaybeAddToListX<T> on List<T> {
  /// Adds [add] to this its not null.
  List<T> maybeAdd(List<T>? add) => maybeAddToList(this, add)!;
}

/// Adds [add] to [source] if both are not null.
Set<T>? maybeAddToSet<T>(Set<T>? source, Set<T>? add) {
  if (source == null) return source;
  if (add == null) return source;
  return {...source, ...add};
}

extension MaybeAddToSetX<T> on Set<T> {
  /// Adds [add] to this its not null.
  Set<T> maybeAdd(Set<T>? add) => maybeAddToSet(this, add)!;
}

/// Adds [add] to [source] if both are not null.
Map<T1, T2>? maybeAddToMap<T1, T2>(Map<T1, T2>? source, Map<T1, T2>? add) {
  if (source == null) return source;
  if (add == null) return source;
  return {...source, ...add};
}

extension MaybeAddToMapX<T1, T2> on Map<T1, T2> {
  /// Adds [add] to this its not null.
  Map<T1, T2> maybeAdd(Map<T1, T2>? add) => maybeAddToMap(this, add)!;
}
