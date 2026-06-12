import 'package:flutter/material.dart';
import 'package:yk_flutter_core/src/widgets/yk_empty_widget.dart';
import 'package:yk_flutter_core/src/widgets/yk_loading_widget.dart';

class YkCoreInfo {
  // 单例实现
  static final YkCoreInfo instance = YkCoreInfo._();

  YkCoreInfo._();

  static Color mainColor = const Color(0xffFFC016);

  static Color bgWhiteColor = Colors.white;

  static Color textColor = const Color(0xFF333333);

  static Widget loadingWidget = YkLoadingWidget(text: "加载中");

  static Widget emptyWidget = YkEmptyWidget();

  dynamic token;

  dynamic config;
}
