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

extension UniqueOnIterableExt<T> on Iterable<T> {
  /// Returns a new iterable with all duplicate elements removed.
  ///
  /// The [equals] function is used to determine if two elements are equal.
  /// If it is not provided, the iterable's elements must be hashable and
  /// the `==` operator is used for equality checks.
  ///
  /// The order of the elements in the returned iterable is the same as
  /// the order in which they appear in the original iterable.
  Iterable<T> unique([bool Function(T a, T b)? equals]) {
    return _unique<T>(this, equals);
  }
}

final _unique = unique;

/// Returns a new iterable with all duplicate elements removed.
///
/// The [equals] function is used to determine if two elements are equal.
/// If it is not provided, the iterable's elements must be hashable and
/// the `==` operator is used for equality checks.
///
/// The order of the elements in the returned iterable is the same as
/// the order in which they appear in the original iterable.
///
/// Without [equals] the result is lazy: each iteration walks [src] afresh,
/// so it can be iterated any number of times and reflects later changes to
/// [src]. With [equals] the result is computed once, eagerly.
Iterable<T> unique<T>(Iterable<T> src, [bool Function(T a, T b)? equals]) {
  if (equals == null) {
    return _uniqueByHash(src);
  } else {
    final uniqueList = <T>[];
    for (var element in src) {
      if (!uniqueList.any((existing) => equals(existing, element))) {
        uniqueList.add(element);
      }
    }
    return uniqueList;
  }
}

/// Yields the first occurrence of each element of [src], using `==` and
/// `hashCode`. A `sync*` body gives every iteration its own `seen` set; a
/// single set shared across iterations would make every element look
/// already-seen on the second pass.
Iterable<T> _uniqueByHash<T>(Iterable<T> src) sync* {
  final seen = <T>{};
  for (final element in src) {
    if (seen.add(element)) yield element;
  }
}
