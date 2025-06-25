
typedef CodeClosure = Future Function(dynamic actionContent);

typedef InAppClosure = Future Function(dynamic data);

typedef ExecuteError = Future Function(String error);

typedef ExecuteActionOnWeb = Future Function(String code, dynamic actionContent);


class YkActionManager {

  static String YkAmGlobalKey = "yk_am_global_type";

  static const String YkAmFuncKey = "yk_am_func_type";

  static const String YkAmDataKey = "yk_am_data";

  // 单例实现
  static final YkActionManager instance = YkActionManager._();

  YkActionManager._();

  Map<String, CodeClosure> _codeMap = {};

  Map<String, InAppClosure> _inAppMap = {};

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
  registerInAppAction(String globalType, String funcType, InAppClosure inAppClosure) {
    _inAppMap["${globalType}_$funcType"] = inAppClosure;
  }

  // 执行 inApp 行为
  Future executeInAppAction(String globalType, String funcType, dynamic data) async {
    if (globalType == "") {
      return;
    }
    if (_inAppMap.keys.contains("${globalType}_$funcType")) {
      return _inAppMap["${globalType}_$funcType"]!(data);
    } else {
      onError?.call("暂不支持该跳转");
      return;
    }
  }
}
