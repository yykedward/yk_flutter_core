import 'package:yk_flutter_core/yk_action_manager.dart';

class YkCoreInfo {
  // 单例实现
  static final YkCoreInfo instance = YkCoreInfo._();

  YkCoreInfo._();

  String? _token;

  dynamic _config;
}

extension YkCoreInfoToken on YkCoreInfo {
  Future<String?> getCoreToken({bool needShowLogin = false}) async {
    if ((_token == null || _token!.isEmpty) && needShowLogin) {
      _token = await YkActionManager.instance.executeAction("110", {
        YkActionManager.YkAmGlobalKey: "private",
        YkActionManager.YkAmFuncKey: "login",
        YkActionManager.YkAmDataKey: {},
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
      YkActionManager.YkAmGlobalKey: "private",
      YkActionManager.YkAmFuncKey: "config",
      YkActionManager.YkAmDataKey: {},
    });
    return _config;
  }

  void clearConfig() {
    _config = null;
  }
}
