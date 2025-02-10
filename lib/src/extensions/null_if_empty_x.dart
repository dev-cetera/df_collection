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

import 'dart:collection' show Queue;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

// Made private but it is public in df_string package.
extension _NullIfEmptyOnStringX on String {
  /// Returns null if the String is empty, otherwise returns the String.
  String? get nullIfEmpty {
    return isEmpty ? null : this;
  }
}

extension NullIfEmptyOnMapX<T1, T2> on Map<T1, T2> {
  /// Returns null if the Map is empty, otherwise returns the Map.
  Map<T1, T2>? get nullIfEmpty {
    return isEmpty ? null : this;
  }
}

extension NullIfEmptyOnIterableX<T> on Iterable<T> {
  /// Returns null if the Iterable is empty, otherwise returns the Iterable.
  Iterable<T>? get nullIfEmpty {
    return isEmpty ? null : this;
  }
}

extension NullIfEmptyOnListX<T> on List<T> {
  /// Returns null if the List is empty, otherwise returns the List.
  List<T>? get nullIfEmpty {
    return isEmpty ? null : this;
  }
}

extension NullIfEmptyOnSetX<T> on Set<T> {
  /// Returns null if the Set is empty, otherwise returns the Set.
  Set<T>? get nullIfEmpty {
    return isEmpty ? null : this;
  }
}

extension NullIfEmptyOnQueueX<T> on Queue<T> {
  /// Returns null if the Queue is empty, otherwise returns the Queue.
  Queue<T>? get nullIfEmpty {
    return isEmpty ? null : this;
  }
}

/// Returns null if [value] is empty, otherwise returns [value].
T? nullIfEmpty<T>(T value) {
  if (value is String) return value.nullIfEmpty as T?;
  if (value is Map) return value.nullIfEmpty as T?;
  if (value is Iterable) return value.nullIfEmpty as T?;
  if (value is List) return value.nullIfEmpty as T?;
  if (value is Set) return value.nullIfEmpty as T?;
  if (value is Queue) return value.nullIfEmpty as T?;
  return value;
}
