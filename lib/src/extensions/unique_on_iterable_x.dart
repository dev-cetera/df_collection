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

extension UniqueOnIterableX<T> on Iterable<T> {
  /// Returns a new iterable with all duplicate elements removed.
  ///
  /// The [equals] function is used to determine if two elements are equal.
  /// If it is not provided, the iterable's elements must be hashable and
  /// the `==` operator is used for equality checks.
  ///
  /// The order of the elements in the returned iterable is the same as
  /// the order in which they appear in the original iterable.
  Iterable<T> unique([
    bool Function(T a, T b)? equals,
  ]) {
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
Iterable<T> unique<T>(
  Iterable<T> src, [
  bool Function(T a, T b)? equals,
]) {
  if (equals == null) {
    final seen = <T>{};
    return src.where((element) => seen.add(element));
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
