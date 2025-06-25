import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:yk_flutter_core/yk_flutter_core.dart';

void main() {
  test('adds one to input values', () async {

    YkActionManager.instance.registerCodeAction("110", (content) {
      final globalType = content[YkActionManager.YkAmGlobalKey] ?? "";
      final funcType = content[YkActionManager.YkAmFuncKey] ?? "";
      final data = content[YkActionManager.YkAmDataKey];
      return YkActionManager.instance.executeInAppAction(globalType, funcType, data);
    });

    YkActionManager.instance.registerInAppAction("private", "login", (data) async {
      Function(dynamic data)? loginSuccess = data["login_success"];
      loginSuccess?.call("123");
      return;
    });

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

    final token = await YkCoreInfo.instance.getCoreToken(needShowLogin: true);

    debugPrint("token: $token");
  });
}
