import 'package:flutter/foundation.dart';

/// 代码行为闭包
typedef CodeClosure = Future<dynamic> Function(dynamic actionContent);

/// 应用内行为闭包
typedef InAppClosure = Future<dynamic> Function(dynamic data);

/// 错误回调
typedef ExecuteError = Future<void> Function(String error);

@immutable
class _YkActionManagerModel {
  final String name;
  final InAppClosure closure;
  final bool didSupportWeb;

  const _YkActionManagerModel({
    required this.name,
    required this.closure,
    this.didSupportWeb = false,
  });
}

/// 行为管理器，支持 code 和 inApp 两种行为注册与执行
class YkActionManager {
  static const String ykAmGlobalKey = "yk_am_global_type";
  static const String ykAmFuncKey = "yk_am_func_type";
  static const String ykAmDataKey = "yk_am_data";

  // 单例实现
  static final YkActionManager instance = YkActionManager._();

  YkActionManager._();

  final Map<String, CodeClosure> _codeMap = {};
  final Map<String, _YkActionManagerModel> _inAppMap = {};

  ExecuteError? _onError;

  set onError(ExecuteError? callback) => _onError = callback;

  /// 注册 code 行为
  void registerCodeAction(String code, CodeClosure closure) {
    _codeMap[code] = closure;
  }

  /// 执行 code 行为
  Future<dynamic> executeAction(String action, dynamic actionContent) async {
    if (_codeMap.containsKey(action)) {
      return _codeMap[action]!(actionContent);
    } else {
      await _onError?.call("暂不支持该跳转");
      return null;
    }
  }

  /// 注册 inApp 行为
  void registerInAppAction(
    String globalType,
    String funcType,
    InAppClosure inAppClosure, {
    bool didSupportWeb = false,
  }) {
    String name = "${globalType}_$funcType";
    _inAppMap[name] = _YkActionManagerModel(
      name: name,
      closure: inAppClosure,
      didSupportWeb: didSupportWeb,
    );
  }

  /// 执行 inApp 行为
  Future<dynamic> executeInAppAction(
    String globalType,
    String funcType,
    dynamic data, {
    Future<void> Function()? webExecuteCallBack,
  }) async {
    if (globalType.isEmpty) {
      return null;
    }
    String name = "${globalType}_$funcType";
    final model = _inAppMap[name];
    if (model != null) {
      if (!model.didSupportWeb && kIsWeb) {
        await webExecuteCallBack?.call();
        return null;
      }
      return model.closure.call(data);
    } else {
      await _onError?.call("暂不支持该跳转");
      return null;
    }
  }
}
