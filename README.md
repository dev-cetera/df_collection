# DF Collection

Dart & Flutter Packages by DevCetra.com & contributors.

[![pub package](https://img.shields.io/pub/v/df_collection.svg)](https://pub.dev/packages/df_collection)

## Summary

A package designed to extend Dart collections by offering additional functionality. For a full feature set, please refer to the [API reference](https://pub.dev/documentation/df_collection/).

## Usage Example

```dart
// Traverse a map using a list of keys and a set a new value.
Map buffer = {};
buffer.traverse([1, 2, 3, 4], newValue: 5);
print(buffer); // {1: {2: {3: {4: 5}}}}
print(buffer.traverse([1, 2, 3, 4])); // 5
```

## Installation

Use this package as a dependency by adding it to your `pubspec.yaml` file (see [here](https://pub.dev/packages/df_collection/install)).

## Contributing and Discussions

This is an open-source project, and contributions are welcome from everyone, regardless of experience level. Contributing to projects is a great way to learn, share knowledge, and showcase your skills to the community. Join the discussions to ask questions, report bugs, suggest features, share ideas, or find out how you can contribute.

### Join GitHub Discussions:

💬 https://github.com/robmllze/df_collection/discussions/

### Join Reddit Discussions:

💬 https://www.reddit.com/r/df_collection/

### Chief Maintainer:

📧 Email _Robert Mollentze_ at robmllze@gmail.com

## License

This project is released under the MIT License. See [LICENSE](https://raw.githubusercontent.com/robmllze/df_collection/main/LICENSE) for more information.
