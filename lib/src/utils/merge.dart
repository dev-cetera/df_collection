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

import 'dart:collection' show Queue;
import 'package:df_type/df_type.dart' show letMapOrNull;

extension _NonNullsOnIterable<T> on Iterable<T?> {
  Iterable<T> get nonNulls => where((e) => e != null).cast<T>();
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Merges two iterable structures. The result does not share any mutable
/// substructure with either input — items are deep-copied where applicable.
Iterable<dynamic> mergeListsSetsOrQueues(
  Iterable<dynamic> a,
  Iterable<dynamic> b, [
  dynamic Function(dynamic)? elseFilter,
]) {
  if (a is Set) {
    final a1 = <dynamic>{
      for (final e in a.nonNulls.cast<dynamic>()) _deepCopy(e),
    };
    final b1 = elseFilter != null
        ? b.nonNulls.cast<dynamic>().map(elseFilter)
        : b.nonNulls.cast<dynamic>().map<dynamic>(_deepCopy);
    return a1..addAll(b1);
  } else if (a is Queue) {
    final a1 = a.nonNulls;
    final b1 = b.nonNulls;
    final mergedList = _performElementWiseMerge(a1, b1, elseFilter);
    return Queue<dynamic>.of(mergedList);
  } else {
    final a1 = a.nonNulls;
    final b1 = b.nonNulls;
    return _performElementWiseMerge(a1, b1, elseFilter);
  }
}

/// Concatenates two iterables (or wraps scalars as single-element iterables).
/// Items that are themselves `Map`s, `List`s, `Set`s or `Queue`s are
/// deep-copied so the result does not alias the inputs.
Iterable<dynamic> mergeIterables(dynamic a, dynamic b) {
  final aa = a is Iterable
      ? a.nonNulls.cast<dynamic>().map<dynamic>(_deepCopy)
      : Iterable<dynamic>.generate(1, (_) => _deepCopy(a));
  final bb = b is Iterable
      ? b.nonNulls.cast<dynamic>().map<dynamic>(_deepCopy)
      : Iterable<dynamic>.generate(1, (_) => _deepCopy(b));
  return aa.followedBy(bb).toList();
}

/// Deeply merges [a] and [b]. The returned structure does not share any
/// mutable substructure with either input — mutating the result is safe and
/// will not affect [a] or [b].
dynamic mergeDataDeep(
  dynamic a,
  dynamic b, [
  dynamic Function(dynamic)? elseFilter,
]) {
  if (a is Map && b is Map) {
    final result = <dynamic, dynamic>{};
    for (final key in a.keys) {
      result[key] = _deepCopy(a[key]);
    }
    for (final key in b.keys) {
      if (result.containsKey(key)) {
        result[key] = mergeDataDeep(result[key], b[key], elseFilter);
      } else {
        result[key] = mergeDataDeep(null, b[key], elseFilter);
      }
    }
    return result;
  }
  if ((a is List || a is Set || a is Queue) && b is Iterable) {
    return mergeListsSetsOrQueues(a as Iterable, b, elseFilter);
  }
  if (a is Iterable && b is Iterable) {
    return mergeIterables(a, b);
  }
  if (elseFilter != null) {
    return elseFilter(b);
  }
  // Default: b wins, but defensively deep-copy any mutable substructure
  // so the caller can't mutate `b` via the returned result.
  return _deepCopy(b);
}

/// Deep-copies a value made up of `Map`s, `List`s, `Set`s and `Queue`s.
/// Scalars (and unknown object types) are returned as-is.
dynamic _deepCopy(dynamic value) {
  if (value is Map) {
    final result = <dynamic, dynamic>{};
    for (final entry in value.entries) {
      result[entry.key] = _deepCopy(entry.value);
    }
    return result;
  }
  if (value is List) {
    return [for (final e in value) _deepCopy(e)];
  }
  if (value is Set) {
    return {for (final e in value) _deepCopy(e)};
  }
  if (value is Queue) {
    return Queue<dynamic>.of([for (final e in value) _deepCopy(e)]);
  }
  return value;
}

Map<K, V> mergeMapsDeep<K, V>(List<Map<K, V>> maps) {
  var a = <K, V>{};
  for (final b in maps) {
    final temp = letMapOrNull<K, V>(mergeDataDeep(a, b));
    if (temp != null) {
      a = temp;
    }
  }
  return a;
}

dynamic mergeDataDeepIncludeCallsToJson(dynamic a, dynamic b) {
  return mergeDataDeep(a, b, tryToJson);
}

dynamic mergeDataDeepIncludeCallsToMap(dynamic a, dynamic b) {
  return mergeDataDeep(a, b, tryToMap);
}

/// Returns `object.toJson()` if it exists, otherwise the object itself.
/// Only swallows `NoSuchMethodError` from a missing `toJson` member — any
/// exception thrown _by_ a present `toJson` propagates to the caller so
/// data-integrity bugs are not hidden.
dynamic tryToJson(dynamic object) {
  if (object == null) return null;
  try {
    return object.toJson();
  } on NoSuchMethodError {
    return object;
  }
}

/// Returns `object.toMap()` if it exists, otherwise the object itself.
/// Only swallows `NoSuchMethodError` from a missing `toMap` member — any
/// exception thrown _by_ a present `toMap` propagates to the caller so
/// data-integrity bugs are not hidden.
dynamic tryToMap(dynamic object) {
  if (object == null) return null;
  try {
    return object.toMap();
  } on NoSuchMethodError {
    return object;
  }
}

List<dynamic> _performElementWiseMerge(
  Iterable<dynamic> a,
  Iterable<dynamic> b, [
  dynamic Function(dynamic)? elseFilter,
]) {
  // Deep-copy a's nested mutable substructures so the result cannot leak
  // shared refs with [a].
  final result = [for (final e in a) _deepCopy(e)];
  final bList = b.toList();
  for (var i = 0; i < bList.length; i++) {
    final itemB = bList[i];
    if (i >= result.length) {
      result.add(mergeDataDeep(null, itemB, elseFilter));
    } else {
      result[i] = mergeDataDeep(result[i], itemB, elseFilter);
    }
  }
  return result;
}
