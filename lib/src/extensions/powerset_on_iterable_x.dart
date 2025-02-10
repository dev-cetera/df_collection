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

extension PowersetOnIterableX<T> on Iterable<Iterable<T>> {
  /// Returns the powerset of the [Iterable] using the provided [combinator].
  ///
  /// The powerset of a set is the set of all possible subsets of the set.
  ///
  /// The [combinator] is a function that combines two elements of the set.
  ///
  /// Example:
  /// ```dart
  /// print(
  ///   powerset({{1}, {2, 3},}, (a, b) => a + b),
  /// ); // prints {3, 4}
  /// ```
  Iterable<T> powerset(T Function(T a, T b) combinator) {
    return _powerset(
      this,
      combinator,
    );
  }
}

final _powerset = powerset;

/// Returns the powerset of the given [source] using the provided [combinator].
///
/// The powerset of a set is the set of all possible subsets of the set.
///
/// The [combinator] is a function that combines two elements of the set.
///
/// Example:
/// ```dart
/// print(
///   powerset({{1}, {2, 3},}, (a, b) => a + b),
/// ); // prints {3, 4}
/// ```
Iterable<T> powerset<T>(
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
      return powerset([firstTwoCombined, ...input.skip(2)], combinator);
    } else {
      return firstTwoCombined;
    }
  }
}
