import 'package:flutter/material.dart';
import 'package:yk_flutter_core/widget/yk_empty_widget.dart';
import 'package:yk_flutter_core/widget/yk_loading_widget.dart';
import 'package:yk_flutter_core/yk_action_manager.dart';

class YkCoreInfo {
  // 单例实现
  static final YkCoreInfo instance = YkCoreInfo._();

  YkCoreInfo._();

  String? _token;

  dynamic _config;

  static Color mainColor = const Color(0xffFFC016);

  static Color bgWhiteColor = Colors.white;

  static Widget loadingWidget = YkLoadingWidget();

  static Widget emptyWidget = YkEmptyWidget();
}

extension YkCoreInfoToken on YkCoreInfo {
  Future<String?> getCoreToken({bool needShowLogin = false}) async {
    if ((_token == null || _token!.isEmpty) && needShowLogin) {
      _token = await YkActionManager.instance.executeAction("110", {
        YkActionManager.ykAmGlobalKey: "private",
        YkActionManager.ykAmFuncKey: "get_token",
        YkActionManager.ykAmDataKey: {},
      });
    }
    return _token;
  }

  void clearToken() {
    _token = null;
  }
}

extension YkCoreInfoConfig on YkCoreInfo {
  Future getConfig() async {
    _config ??= await YkActionManager.instance.executeAction("110", {
      YkActionManager.ykAmGlobalKey: "private",
      YkActionManager.ykAmFuncKey: "config",
      YkActionManager.ykAmDataKey: {},
    });
    return _config;
  }

  void clearConfig() {
    _config = null;
  }
}
