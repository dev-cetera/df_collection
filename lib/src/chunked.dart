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

extension ChunkedOnIterableExtension<T> on Iterable<T> {
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

/// Helper function that creates chunks from the provided [Iterable].
///
/// [source] is the Iterable to split, and [batchSize] defines the maximum
/// size for each chunk. It generates the chunks lazily as the Iterable is
/// processed.
Iterable<Iterable<T>> _chunked<T>(
  Iterable<T> source,
  int batchSize,
) sync* {
  var batch = <T>[];
  for (final item in source) {
    batch.add(item);
    if (batch.length == batchSize) {
      yield batch;
      batch = <T>[];
    }
  }
  if (batch.isNotEmpty) {
    yield batch;
  }
}