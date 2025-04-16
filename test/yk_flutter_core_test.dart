import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:yk_flutter_core/yk_flutter_core.dart';

void main() {
  test('adds one to input values', () {

    YkFileManager.getDocumentPath().then((value) async {
      final path = "$value/text.demo";
      await YkFileManager.save(bytes: Int8List.fromList(utf8.encode("nihao")), filePath: path);
      return path;
    }).then((value) async {
      final data = await YkFileManager.getData(path: value);

      final text = utf8.decode(data ?? []);

      return text;
    }).then((value) {
      debugPrint(value);
    });
  });
}
