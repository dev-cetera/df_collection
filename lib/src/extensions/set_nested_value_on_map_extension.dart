//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Dart/Flutter (DF) Packages by DevCetra.com & contributors. Use of this
// source code is governed by an MIT-style license that can be found in the
// LICENSE file.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

extension SetNestedValueOnMapExtension on Map {
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
      currentLevel = currentLevel.putIfAbsent(keyPath[n], () => {});
    }
    currentLevel[keyPath.last] = value;
  }
}
