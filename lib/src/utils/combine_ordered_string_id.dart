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

/// Generates an ordered ID from a list of unordered IDs, that can be
/// used to identify the list of IDs.
///
/// For example, this can be used to combine user IDs into a single ID that
/// represents the group of users.
///
/// Throws [ArgumentError] if:
/// - any ID is empty — `['', 'a']` and `['a']` would otherwise both look
///   identifying but represent different inputs;
/// - any ID contains the [separator] (default `_`) — this would allow
///   different inputs to produce the same combined ID (e.g. `['a', 'b_c']`
///   and `['a_b', 'c']`).
String combinedOrderedStringId(
  List<String> ids, {
  String separator = '_',
}) {
  if (separator.isEmpty) {
    throw ArgumentError.value(separator, 'separator', 'must not be empty');
  }
  for (final id in ids) {
    if (id.isEmpty) {
      throw ArgumentError.value(id, 'ids', 'ID must not be empty');
    }
    if (id.contains(separator)) {
      throw ArgumentError.value(
        id,
        'ids',
        'ID must not contain the separator "$separator"',
      );
    }
  }
  final sorted = List.of(ids)..sort((a, b) => a.compareTo(b));
  return sorted.join(separator);
}
