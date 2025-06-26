import 'package:flutter/foundation.dart';

typedef CodeClosure = Future Function(dynamic actionContent);

typedef InAppClosure = Future Function(dynamic data);

typedef ExecuteError = Future Function(String error);


class _YkActionManagerModel {
  final String name;
  final InAppClosure closure;
  bool didSupportWeb = false;

  _YkActionManagerModel({required this.name, required this.closure, this.didSupportWeb = false});
}

class YkActionManager {

  static const String YkAmGlobalKey = "yk_am_global_type";

  static const String YkAmFuncKey = "yk_am_func_type";

  static const String YkAmDataKey = "yk_am_data";

  // 单例实现
  static final YkActionManager instance = YkActionManager._();

  YkActionManager._();

  Map<String, CodeClosure> _codeMap = {};

  Map<String, _YkActionManagerModel> _inAppMap = {};

  ExecuteError? onError;

  // 注册 code 行为
  registerCodeAction(String code, CodeClosure closure) {
    _codeMap[code] = closure;
  }

  // 执行 code 行为
  Future executeAction(String action, dynamic actionContent) async {
    if (_codeMap.keys.contains(action)) {
      return _codeMap[action]!(actionContent);
    } else {
      onError?.call("暂不支持该跳转");
      return;
    }
  }

  // 注册 inApp 行为
  registerInAppAction(String globalType, String funcType, InAppClosure inAppClosure, {bool didSupportWeb = false}) {
    String name = "${globalType}_$funcType";
    _inAppMap[name] = _YkActionManagerModel(
      name: name,
      closure: inAppClosure,
      didSupportWeb: didSupportWeb,
    );
  }

  // 执行 inApp 行为
  Future executeInAppAction(String globalType, String funcType, dynamic data, {Future Function()? webExecuteCallBack}) async {
    if (globalType == "") {
      return;
    }
    String name = "${globalType}_$funcType";
    if (_inAppMap.keys.contains(name)) {
      final model = _inAppMap[name];
      if ((model?.didSupportWeb == false) && (kIsWeb)) {
        await webExecuteCallBack?.call();
        return;
      }
      return model?.closure.call(data);
    } else {
      onError?.call("暂不支持该跳转");
      return;
    }
  }
}
