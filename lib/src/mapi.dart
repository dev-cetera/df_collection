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

extension MapIOnIterableExtension<A> on Iterable<A> {
  /// Maps an iterable with an index and an optional option.
  Iterable<B> mapi<B, C>(
    B Function(A e, int index, C? option) mapper, {
    List<C> options = const [],
  }) {
    var index = 0;
    return map((e) {
      final option = options.length > index ? options[index] : null;
      return mapper(e, index++, option);
    });
  }
}

extension MapIOnListExtension<A> on List<A> {
  /// Maps a list with an index and an optional option.
  Iterable<B> mapi<B, C>(
    B Function(A e, int index, C? option) mapper, {
    List<C> options = const [],
  }) {
    var index = 0;
    return map((e) {
      final option = options.length > index ? options[index] : null;
      return mapper(e, index++, option);
    });
  }
}

extension MapIOnSetExtension<A> on Set<A> {
  /// Maps a set with an index and an optional option.
  Iterable<B> mapi<B, C>(
    B Function(A e, int index, C? option) mapper, {
    List<C> options = const [],
  }) {
    var index = 0;
    return map((e) {
      final option = options.length > index ? options[index] : null;
      return mapper(e, index++, option);
    });
  }
}

extension MapIOnMapExtension<A1, A2> on Map<A1, A2> {
  /// Maps a map with an index and an optional option.
  Map<B1, B2> mapi<B1, B2, C>(
    MapEntry<B1, B2> Function(A1 e1, A2 e2, int index, C? option) mapper, {
    List<C> options = const [],
  }) {
    var index = 0;
    return map((e1, e2) {
      final option = options.length > index ? options[index] : null;
      return mapper(e1, e2, index++, option);
    });
  }
}
