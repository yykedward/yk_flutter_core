import 'dart:async';

class YkNotification {
  final String name;

  final dynamic object;

  final Map<String, dynamic>? userInfo;

  YkNotification(this.name, this.object, this.userInfo);
}

typedef YkNotificationCenterCallBack = void Function(YkNotification notification)?;

class YkNotificationCenter {
  static final YkNotificationCenter instance = YkNotificationCenter._();

  YkNotificationCenter._();

  final StreamController<Map<String, YkNotification>> _observerStream = StreamController<Map<String, YkNotification>>.broadcast();

  void post(String name, {dynamic object, Map<String, dynamic>? userInfo}) {
    final notification = YkNotification(name, object, userInfo);
    _observerStream.sink.add({name: notification});
  }

  StreamSubscription addObserver(String name, YkNotificationCenterCallBack callBack) {
    return _observerStream.stream.listen((event) {
      final notification = event[name];
      if (notification != null) {
        callBack?.call(notification);
      }
    });
  }

  void dispose() {
    _observerStream.close();
  }
}
