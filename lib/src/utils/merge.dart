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

Iterable<dynamic> mergeListsSetsOrQueues(
  Iterable<dynamic> a,
  Iterable<dynamic> b, [
  dynamic Function(dynamic)? elseFilter,
]) {
  if (a is Set) {
    final a1 = a.nonNulls.toSet();
    final b1 = b.nonNulls;
    return a1..addAll(b1);
  } else if (a is Queue) {
    final a1 = a.nonNulls;
    final b1 = b.nonNulls;
    final mergedList = _performElementWiseMerge(a1, b1, elseFilter);
    return Queue.of(mergedList);
  } else {
    final a1 = a.nonNulls;
    final b1 = b.nonNulls;
    return _performElementWiseMerge(a1, b1, elseFilter);
  }
}

Iterable<dynamic> mergeIterables(dynamic a, dynamic b) {
  final aa = a is Iterable ? a.nonNulls : Iterable.generate(1, (_) => a);
  final bb = b is Iterable ? b.nonNulls : Iterable.generate(1, (_) => b);
  return aa.followedBy(bb);
}

dynamic mergeDataDeep(
  dynamic a,
  dynamic b, [
  dynamic Function(dynamic)? elseFilter,
]) {
  if (a is Map && b is Map) {
    final result = Map<dynamic, dynamic>.from(a);
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
  } else {
    return b;
  }
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

dynamic tryToJson(dynamic object) {
  try {
    return object?.toJson();
  } catch (_) {
    return object;
  }
}

dynamic tryToMap(dynamic object) {
  try {
    return object?.toMap();
  } catch (_) {
    return object;
  }
}

List<dynamic> _performElementWiseMerge(
  Iterable<dynamic> a,
  Iterable<dynamic> b, [
  dynamic Function(dynamic)? elseFilter,
]) {
  final result = a.toList();
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
