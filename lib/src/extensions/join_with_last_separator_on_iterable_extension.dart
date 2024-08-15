//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Dart/Flutter (DF) Packages by DevCetra.com & contributors. Use of this
// source code is governed by an MIT-style license that can be found in the
// LICENSE file.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

extension JoinWithLastSeparatorOnIterableExtension on Iterable {
  /// Joins the elements of the iterable into a single string with the given
  /// [separator] and [lastSeparator]. The [lastSeparator] is used to join the
  /// last two elements of the iterable.
  String joinWithLastSeparator({
    String separator = ', ',
    String lastSeparator = ' & ',
  }) {
    if (isEmpty) {
      return '';
    }
    if (length == 1) {
      return first;
    }
    final list = toList();
    if (length == 2) {
      return list.join(lastSeparator);
    }

    final lastTwo = list.sublist(list.length - 2).join(lastSeparator);
    final allButLastTwo = list.sublist(0, list.length - 2).join(separator);
    return '$allButLastTwo$separator$lastTwo';
  }
}
