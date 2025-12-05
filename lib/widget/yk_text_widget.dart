import 'package:flutter/material.dart';

class YkTextWidget extends Text {
  YkTextWidget(
    super.data, {
    super.key,
    TextStyle? style,
    super.textAlign,
    super.textDirection,
    super.locale,
    super.softWrap,
    super.overflow,
    super.textScaleFactor,
    super.maxLines,
    String fontFamily = '', // 设置默认字体
  }) : super(
          style: (fontFamily.isNotEmpty) ? style?.copyWith(fontFamily: fontFamily) : style,
        );
}
