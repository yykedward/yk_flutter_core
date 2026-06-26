# yk_flutter_core

Flutter 核心工具库，提供文件管理、权限处理、动作路由、日志系统、通知中心和可复用 UI 组件。

[English](README.md) | [中文](README_zh.md)

## 安装

```yaml
dependencies:
  yk_flutter_core: ^0.0.16
```

## 快速开始

```dart
import 'package:yk_flutter_core/yk_flutter_core.dart';
```

所有类通过 barrel 统一导出。

## 模块

### YkFileManager

跨平台文件操作。所有方法在 Web 环境返回 false/null。

```dart
await YkFileManager.save(bytes: data, filePath: '/path/to/file');
final bytes = await YkFileManager.getData(path: '/path/to/file');
final exists = await YkFileManager.exists(path: '/path/to/file');
await YkFileManager.deleteFile(path: '/path/to/file');
```

### YkPermission

统一权限请求，Android 相册权限 SDK 版本自适应，Web 平台自动返回 false。

```dart
final granted = await YkPermission.check(
  type: YkPermissionType.camera,
  onDenied: (openSettings) async {
    await openSettings();
    return false;
  },
);
// 支持类型: mic, camera, photo, notification, file
```

### YkActionManager

集中式动作注册与执行。支持 code 和 inApp 两级路由。

```dart
YkActionManager.instance.registerCodeAction('login', (data) async {
  return 'result';
});
final result = await YkActionManager.instance.executeAction('login', payload);

YkActionManager.instance.onError = (error) async {
  print('Action error: $error');
};
```

### YkLog

委托模式日志，调试模式自动回退到 `dart:developer`。

```dart
class MyLogger with YkLogDelegate {
  Future log(String msg) async => print(msg);
  Future error(String msg) async => print(msg);
}

YkLog.init(delegate: MyLogger());
await YkLog.log(msg: 'App started');
```

### YkDigLogUtil

持久化日志，支持文件轮转（默认 5KB）、归档和上传。

```dart
await YkDigLogUtil.setup(delegate: YkDigLogUtilDelegate(
  setup: () async {},
  uploadCallBack: (data) async => true,
  saveDocumentPath: () async => '/logs',
));

YkDigLogUtil.addLog(event: 'click', title: 'Button', params: {'id': 1});
await YkDigLogUtil.archiveAndUpload();
```

### YkNotificationCenter

观察者模式事件总线，基于 `StreamController.broadcast`。

```dart
final sub = YkNotificationCenter.instance.addObserver('event', (n) {
  print(n.object);
});

YkNotificationCenter.instance.post('event', object: data, userInfo: {'key': 'v'});
sub.cancel();
YkNotificationCenter.instance.dispose(); // 释放 StreamController
```

### YkCoreInfo

全局配置单例：主题色、加载/空状态组件、运行时 token/config。

```dart
YkCoreInfo.mainColor = Color(0xFFFFC016);
final token = YkCoreInfo.instance.token;
YkCoreInfo.loadingWidget = MyCustomLoadingWidget();
```

### YkCoreExtension

Dart 扩展方法。

```dart
1640995200000.formatTime();                // "2022-01-01 00:00:00"
'1640995200000'.formatTime();              // 字符串时间戳 → 格式化
DateTime.now().formatTime();               // DateTime → 格式化
originalMap.deepCopy();                    // Map/List 深拷贝，其他类型返回原值
```

### UI 组件

| 组件 | 说明 |
|------|------|
| `YkClickWidget` | 防重复点击，可配置间隔（默认 1000ms），支持 onDoubleTap |
| `YkFutureWidget<T>` | FutureBuilder 封装，自动处理 loading/empty 状态，回退到 YkCoreInfo 默认值 |
| `YkLoadingWidget` | 统一加载指示器，可选文本 |
| `YkEmptyWidget` | 统一空状态组件，可选文本 |
| `YkTextWidget` | Text 子类，支持自定义 fontFamily |

## 架构

```
lib/
├── yk_flutter_core.dart          ← barrel
└── src/
    ├── managers/   YkActionManager, YkNotificationCenter
    ├── services/   YkFileManager, YkPermission, YkDigLogUtil, YkLogWriter
    ├── logging/    YkLog
    ├── core/       YkCoreInfo, YkState
    ├── extensions/ YkCoreExtension
    └── widgets/    YkClickWidget, YkFutureWidget, ...
```

**设计模式**：核心类使用单例（`static final instance`），日志系统使用委托模式（mixin/class），所有 I/O 模块包含 `kIsWeb` 守卫。

## License

MIT
