# Changelog

## 0.11.0

- breaking: `mergeDataDeep` now deep-copies all mutable substructure into its result — mutating the merged result no longer mutates the input data. Same guarantee for `mergeListsSetsOrQueues` and `mergeIterables`. Prior versions silently shared `Map`/`List`/`Set`/`Queue` references between the result and the inputs, which was a data-integrity hazard.
- breaking: `JsonUtility.flattenJson` now throws `StateError` when (a) any key contains the separator (would produce an ambiguous flat path) or (b) two distinct source paths would flatten to the same flat key (silent overwrite of data). Previously the colliding entry was silently dropped.
- breaking: `JsonUtility.mapToJson` now rejects `NaN` and `±Infinity` doubles with `UnsupportedError` — not representable in standard JSON, previously slipped through only to break `jsonEncode` downstream.
- breaking: `setNestedValue` on a non-`Map` intermediate now throws `StateError` instead of silently overwriting the existing value. Pass `overwriteIntermediates: true` to opt into the old behaviour. An empty `keyPath` is now a safe no-op instead of throwing.
- breaking: `tryToJson` / `tryToMap` now only swallow `NoSuchMethodError` (the "no such member" case). Exceptions thrown by a present `toJson` / `toMap` propagate.
- breaking: `tryReduce` / `tryMerge` now only convert the "empty iterable" case into `null`. Exceptions from the user's combine/merge function propagate (previously `Error` subclasses including `StackOverflowError` were silently swallowed).
- breaking: `combinedOrderedStringId` now throws `ArgumentError` when an ID is empty, contains the separator (would otherwise yield silent ID collisions), or when an empty separator is passed. New optional `separator` parameter (default `_`).
- breaking: `deepGetFromSegments` refuses to index into non-`List` iterables (notably `Set`) — element order is implementation-defined there. Also refuses fractional indices (e.g. `"3.5"`) instead of silently truncating.
- breaking: `chunked` throws `ArgumentError` for non-positive `chunkSize` instead of silently yielding a single chunk.
- fix: `CsvUtility.csvToMap` is now an RFC 4180 parser: handles CRLF / bare-CR line terminators, newlines inside quoted fields, escaped quotes, and preserves significant leading/trailing whitespace. Blank lines no longer renumber subsequent rows.
- fix: `CsvUtility.mapToCsv` now quotes fields containing `\r` per RFC 4180.
- fix: `deepGetFromSegments` now returns the resolved value instead of always `null`.
- fix: `takeLast(count)` no longer throws when `count` exceeds the iterable's length; returns the full iterable.
- fix: `traverseMap` write returns the written value, and no longer throws when the intermediate path crosses a non-map node.
- fix: `mergeIterables` no longer throws a `TypeError` when one argument is a scalar and the other is a typed iterable.
- fix: `JsonUtility.mapToJson` now accepts `null` values (was throwing `UnsupportedError`).
- fix: `JsonUtility.flattenJson` no longer silently drops keys whose values are empty maps or lists.
- fix: `mergeListsSetsOrQueues` now applies `elseFilter` to the b-side in the `Set` branch (was previously skipped).
- `MaybeAddToIterableExt.maybeAdd` return type tightened from `Iterable<T>?` to `Iterable<T>`.
