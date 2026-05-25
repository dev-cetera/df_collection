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

extension SetNestedValueOnMapExt on Map<dynamic, dynamic> {
  /// Sets a [value] in a nested map structure, creating intermediate maps as
  /// needed.
  ///
  /// Traverses the [keyPath] in the map. Missing intermediate keys are
  /// created as empty maps. If an intermediate key already maps to a value
  /// that is **not** a `Map`, the call throws [StateError] rather than
  /// silently overwriting the value — silent overwrite would be a data-loss
  /// hazard. To intentionally overwrite, pass `overwriteIntermediates: true`.
  ///
  /// Calling with an empty [keyPath] is a no-op.
  ///
  /// **Example:**
  ///
  /// ```dart
  /// final map = <String, dynamic>{};
  /// map.setNestedValue(['hello', 'world'], 'oh hey there!');
  /// print(map); // {hello: {world: oh hey there!}}
  /// ```
  void setNestedValue(
    List<dynamic> keyPath,
    dynamic value, {
    bool overwriteIntermediates = false,
  }) {
    if (keyPath.isEmpty) return;
    var currentLevel = this;
    for (var n = 0; n < keyPath.length - 1; n++) {
      final key = keyPath[n];
      final nextLevel = currentLevel[key];
      if (nextLevel is Map<dynamic, dynamic>) {
        currentLevel = nextLevel;
      } else if (nextLevel == null || overwriteIntermediates) {
        final newMap = <dynamic, dynamic>{};
        currentLevel[key] = newMap;
        currentLevel = newMap;
      } else {
        throw StateError(
          '[setNestedValue] Cannot descend through key '
          '"${keyPath.sublist(0, n + 1).join('/')}" — existing value is a '
          '${nextLevel.runtimeType}, not a Map. Pass '
          'overwriteIntermediates: true to overwrite it.',
        );
      }
    }
    currentLevel[keyPath.last] = value;
  }
}
