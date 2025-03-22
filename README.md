<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

### YkFileManager

```dart getDocumentPath

YkFileManager.getDocumentPath();

```

```dart save


      final data = Int8List.fromList(utf8.encode("fawoeigjaowiegjoiawjegoiawjegoiawejgo"));

      final documentPath = await YkFileManager.getDocumentPath();

      String newFilePath = "$documentPath/Yk/Document/text.txt";

      final result = await YkFileManager.save(bytes: data, filePath:newFilePath);
```

```dart getData
final documentPath = await YkFileManager.getDocumentPath();

String newFilePath = "$documentPath/Yk/Document/text.txt";

final detail = await YkFileManager.getData(path: newFilePath);

final andoder = utf8.decode(detail ?? []);
```

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
const like = 'sample';
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
