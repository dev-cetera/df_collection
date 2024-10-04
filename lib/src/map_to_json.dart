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

/// Converts a map to a Json map by recursively converting its keys and values
/// to Json compatible types.
Map<String, dynamic> mapToJson<T1, T2>(
  Map<T1, T2> input, {
  Set<Type> typesAllowed = const {},
  String? Function(dynamic)? keyConverter,
}) {
  return _mapToJson(
    input,
    typesAllowed,
    keyConverter,
  ) as Map<String, dynamic>;
}

dynamic _mapToJson(
  dynamic input,
  Set<Type> typesAllowed,
  String? Function(dynamic)? keyConverter,
) {
  if (input is Map) {
    return input.map(
      (k, v) => MapEntry(
        keyConverter?.call(k) ?? _defaultKeyConverter(k) ?? k.toString(),
        _mapToJson(
          v,
          typesAllowed,
          keyConverter,
        ),
      ),
    );
  } else if (input is Iterable) {
    return input.map((e) => _mapToJson(e, typesAllowed, keyConverter)).toList();
  }
  if ({
    bool,
    String,
    int,
    double,
    num,
    ...typesAllowed,
  }.contains(input.runtimeType)) {
    return input;
  }
  assert(
    false,
    '[mapToJson] Unsupported type "${input.runtimeType}"',
  );
  return input.toString();
}

String? _defaultKeyConverter(dynamic key) {
  if (key is DateTime) {
    return key.microsecondsSinceEpoch.toString();
  }
  return null;
}