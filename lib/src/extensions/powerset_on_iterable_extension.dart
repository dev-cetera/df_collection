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

extension PowersetOnIterableExtension<T> on Iterable<Iterable<T>> {
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
  // Filter out empty sets to simplify logic
  final input = source.where((e) => e.isNotEmpty).toList();

  if (input.isEmpty) {
    return {};
  } else if (input.length == 1) {
    return input[0];
  } else {
    // Combine the first two sets using the provided combinator
    final combined = <T>{};
    for (final a in input[0]) {
      for (final b in input[1]) {
        combined.add(combinator(a, b));
      }
    }

    // Recursively process the remaining sets
    return powerset(
      [
        combined,
        ...input.skip(2),
      ],
      combinator,
    );
  }
}
