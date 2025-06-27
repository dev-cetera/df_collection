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

extension ChunkedOnIterableExt<T> on Iterable<T> {
  /// Splits the [Iterable] into chunks of a maximum size specified by [chunkSize].
  ///
  /// Each chunk is yielded as a separate [Iterable]. If the number of elements
  /// is not perfectly divisible by [chunkSize], the last chunk will contain
  /// the remaining elements.
  ///
  /// Example:
  /// ```dart
  /// final numbers = [1, 2, 3, 4, 5];
  /// final chunks = numbers.chunked(2).toList();
  /// print(chunks); // [[1, 2], [3, 4], [5]]
  /// ```
  Iterable<Iterable<T>> chunked(int chunkSize) {
    return _chunked<T>(this, chunkSize);
  }
}

final _chunked = chunked;

/// Splits the [source] into chunks of a maximum size specified by [chunkSize].
///
/// Each chunk is yielded as a separate [Iterable]. If the number of elements
/// is not perfectly divisible by [chunkSize], the last chunk will contain
/// the remaining elements.
///
/// Example:
/// ```dart
/// final numbers = [1, 2, 3, 4, 5];
/// final chunks = numbers.chunked(2).toList();
/// print(chunks); // [[1, 2], [3, 4], [5]]
/// ```
Iterable<Iterable<T>> chunked<T>(Iterable<T> source, int chunkSize) sync* {
  var batch = <T>[];
  for (final item in source) {
    batch.add(item);
    if (batch.length == chunkSize) {
      yield batch;
      batch = <T>[];
    }
  }
  if (batch.isNotEmpty) {
    yield batch;
  }
}
