import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

mixin YkLogDelegate {
  Future log(String msg);

  Future error(String msg);
}

class YkLog {
  final Logger _logger = Logger('YkLog');

  // 单例实现
  static final YkLog _instance = YkLog._();

  YkLog._();

  YkLogDelegate? _delegate;

  static init({required YkLogDelegate delegate}) {
    YkLog._instance._delegate = delegate;
  }

  static Future log({required String msg}) async {
    if (YkLog._instance._delegate != null) {
      YkLog._instance._delegate?.log(msg);
    } else {
      if (kDebugMode) {
        developer.log("YkLog log : $msg");
      } else {
        YkLog._instance._logger.warning(msg);
      }
    }
  }

  static Future error({required String msg}) async {
    if (YkLog._instance._delegate != null) {
      YkLog._instance._delegate?.error(msg);
    } else {
      if (kDebugMode) {
        developer.log("YkLog error : $msg");
      } else {
        YkLog._instance._logger.severe(msg);
      }
    }
  }
}
