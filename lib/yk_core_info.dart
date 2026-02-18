import 'package:flutter/material.dart';
import 'package:yk_flutter_core/widget/yk_empty_widget.dart';
import 'package:yk_flutter_core/widget/yk_loading_widget.dart';
import 'package:yk_flutter_core/yk_action_manager.dart';

class YkCoreInfo {
  // 单例实现
  static final YkCoreInfo instance = YkCoreInfo._();

  YkCoreInfo._();

  static Color mainColor = const Color(0xffFFC016);

  static Color bgWhiteColor = Colors.white;

  static Color textColor = const Color(0xFF333333);

  static Widget loadingWidget = YkLoadingWidget(text: "加载中");

  static Widget emptyWidget = YkEmptyWidget();

  Future<dynamic> getCoreToken({bool needShowLogin = false}) {
    return YkActionManager.instance.executeAction("110", {
      YkActionManager.ykAmGlobalKey: "yk_private",
      YkActionManager.ykAmFuncKey: "get_token",
      YkActionManager.ykAmDataKey: {
        "need_login": needShowLogin,
      },
    });
  }

  Future getConfig() {
    return YkActionManager.instance.executeAction("110", {
      YkActionManager.ykAmGlobalKey: "yk_private",
      YkActionManager.ykAmFuncKey: "config",
      YkActionManager.ykAmDataKey: {},
    });
  }
}
