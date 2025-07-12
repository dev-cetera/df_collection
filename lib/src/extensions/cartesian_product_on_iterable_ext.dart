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

extension CartesianProductOnIterableExt<T> on Iterable<Iterable<T>> {
  /// Creates the Cartesian product of the iterables and combines each resulting
  /// pair using the [combinator] function.
  ///
  /// Example:
  /// ```dart
  /// final sets = [{1, 2}, {10, 20}];
  /// final combined = sets.cartesianProduct((a, b) => a + b);
  /// print(combined); // (11, 21, 12, 22)
  /// ```
  Iterable<T> cartesianProduct(T Function(T a, T b) combinator) {
    return _cartesianProduct(this, combinator);
  }
}

final _cartesianProduct = cartesianProduct;

/// Creates the Cartesian product of the iterables and combines each resulting
/// pair using the [combinator] function.
///
/// Example:
/// ```dart
/// final sets = [{1, 2}, {10, 20}];
/// final combined = sets.cartesianProduct((a, b) => a + b);
/// print(combined); // (11, 21, 12, 22)
/// ```
Iterable<T> cartesianProduct<T>(
  Iterable<Iterable<T>> source,
  T Function(T a, T b) combinator,
) {
  // Filter out empty sets to simplify logic.
  final input = source.where((e) => e.isNotEmpty);

  if (input.isEmpty) {
    return Iterable.empty();
  } else if (input.length == 1) {
    // Return the first iterable if only one exists.
    return input.first;
  } else {
    // Use expand to create a lazy flattened iterable from the first two sets.
    final firstTwoCombined = input.elementAt(0).expand((a) {
      return input.elementAt(1).map((b) => combinator(a, b));
    });

    // If more sets remain, recursively process them.
    if (input.length > 2) {
      return cartesianProduct([firstTwoCombined, ...input.skip(2)], combinator);
    } else {
      return firstTwoCombined;
    }
  }
}
