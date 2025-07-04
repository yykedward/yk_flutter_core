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

## Features

### YkFileManager

#### 获取存储路径
```dart getDocumentPath
YkFileManager.getDocumentPath();
```
#### 保存内容，但需要把保存的内容先进行转化成二进制data， 保存成功将返回bool
```dart save
  final data = Int8List.fromList(utf8.encode("fawoeigjaowiegjoiawjegoiawjegoiawejgo"));

  final documentPath = await YkFileManager.getDocumentPath();

  String newFilePath = "$documentPath/text.txt";

  final result = await YkFileManager.save(bytes: data, filePath:newFilePath);
```

#### 获取内容, 根据路径返回内容
```dart getData
final documentPath = await YkFileManager.getDocumentPath();

String newFilePath = "$documentPath/text.txt";

final detail = await YkFileManager.getData(path: newFilePath);

final andoder = utf8.decode(detail ?? []);
```



