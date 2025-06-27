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

extension SetNestedValueOnMapExt on Map<dynamic, dynamic> {
  /// Sets a [value] in a nested map structure, creating intermediate maps as
  /// needed.
  ///
  /// Traverses the [keyPath] in the map, creating empty maps for any missing
  /// intermediate keys, and sets the [value] at the final key in the path.
  ///
  /// **Example:**
  ///
  /// ```dart
  /// final map = <String, dynamic>{};
  /// map.setNestedValue(['hello', 'world'], 'oh hey there!');
  /// print(map); // {hello: {world: oh hey there!}}
  /// ```
  void setNestedValue(List<dynamic> keyPath, dynamic value) {
    var currentLevel = this;
    for (var n = 0; n < keyPath.length - 1; n++) {
      final key = keyPath[n];
      final nextLevel = currentLevel[key];
      if (nextLevel is Map<dynamic, dynamic>) {
        currentLevel = nextLevel;
      } else {
        final newMap = <dynamic, dynamic>{};
        currentLevel[key] = newMap;
        currentLevel = newMap;
      }
    }
    currentLevel[keyPath.last] = value;
  }
}
