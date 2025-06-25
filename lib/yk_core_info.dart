import 'package:yk_flutter_core/yk_action_manager.dart';

class YkCoreInfo {
  // 单例实现
  static final YkCoreInfo instance = YkCoreInfo._();

  YkCoreInfo._();

  String? _token;

  Future<String?> getCoreToken({bool needShowLogin = false}) async {
    if ((_token == null || _token!.isEmpty) && needShowLogin) {
      await YkActionManager.instance.executeAction("110", {
        YkActionManager.YkAmGlobalKey: "private",
        YkActionManager.YkAmFuncKey: "login",
        YkActionManager.YkAmDataKey: {
          "login_success": (token) {
            _token = token;
          }
        }
      });
    }
    return _token;
  }

  void clearToken() {
    _token = null;
  }
}
