## Summary

A package designed to extend Dart collections by offering additional functionality.

## Example

```dart
// Create the cartesian product from a list of sets.
{
  final items = [
    {1, 2},
    {3, 4, 5},
  ];
  final batches = items.cartesianProduct((a, b) => a + b);
  print(batches); // [4, 5, 6, 5, 6, 7]
}

// Split a list into chunks of a maximum size.
{
  final items = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  final batches = items.chunked(4);
  print(batches); // ([1, 2, 3, 4], [5, 6, 7, 8], [9])
}

// Traverse a map using a list of keys and a set a new value.
{
  var buffer = <dynamic, dynamic>{};
  buffer.traverse([1, 2, 3, 4], newValue: 5);
  print(buffer); // {1: {2: {3: {4: 5}}}}
  print(buffer.traverse([1, 2, 3, 4])); // 5
}
```
