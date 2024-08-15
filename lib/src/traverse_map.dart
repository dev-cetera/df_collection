//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Dart/Flutter (DF) Packages by DevCetra.com & contributors. Use of this
// source code is governed by an MIT-style license that can be found in the
// LICENSE file.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

/// Traverses a [Map] using a list of keys. If the keys do not exist, they are
/// created. If [newValue] is provided, the value at the end of the traversal is
/// set to [newValue].
///
/// Returns the value at the end of the traversal.
dynamic traverseMap(Map map, Iterable keys, {dynamic newValue}) {
  dynamic current = map;
  for (var n = 0; n < keys.length; n++) {
    final key = keys.elementAt(n);
    if (n == keys.length - 1) {
      if (newValue != null) {
        current[key] = newValue;
        return;
      } else {
        return current[key];
      }
    } else {
      if (current is Map && current.containsKey(key)) {
        current = current[key];
      } else {
        if (newValue != null) {
          current[key] = {};
          current = current[key];
        } else {
          return null;
        }
      }
    }
  }
  return null;
}
