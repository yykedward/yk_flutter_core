# yk_flutter_core

一个全面的 Flutter 核心工具库，提供基础工具和组件以简化移动应用开发流程。该包提供文件管理、权限处理、动作管理、日志记录、通知系统和可重用 UI 组件。

[English Version](README.md) | [中文版本](README_zh.md)

## 功能特性

### 📁 文件管理 (`YkFileManager`)
- 跨平台文件操作（Android/iOS）
- 获取文档存储路径
- 递归创建目录
- 将二进制数据保存到文件
- 以字节形式读取文件内容
- 删除文件和检查文件是否存在
- Web 平台兼容性检查

### 🔒 权限管理 (`YkPermission`)
- 常见用例的统一权限处理
- 支持麦克风、相机、相册、通知和存储权限
- Android SDK 版本感知的相册权限处理
- 可自定义的拒绝回调和设置导航
- 自动权限请求流程

### 🎯 动作管理 (`YkActionManager`)
- 集中式动作注册和执行系统
- 支持基于代码和应用内行为模式
- 全局和函数类型动作分类
- 带自定义错误回调的错误处理
- 单例模式确保一致访问

### 📊 核心信息 (`YkCoreInfo`)
- 集中式应用配置和样式
- 预定义的颜色方案和 UI 常量
- 标准化的加载和空状态组件
- 核心令牌和配置检索工具
- 应用间一致的主题

### 📝 日志系统 (`YkLog`)
- 基于委托模式的灵活日志记录
- 调试模式控制台输出回退
- 自定义日志实现支持
- 错误和信息日志分离
- 易于集成外部日志服务

### 📈 数字日志 (`YkDigLogUtil`)
- 带文件持久化的高级日志记录
- 自动日志轮转和归档
- 用于远程日志的上传回调系统
- 可配置的文件大小限制（默认 5KB）
- 基于队列的异步写入
- Web 平台兼容性

### 🔔 通知中心 (`YKNotificationCenter`)
- 用于事件广播的观察者模式实现
- 带可选数据负载的命名通知
- UserInfo 字典支持额外上下文
- 基于流的订阅系统
- 内存高效的广播架构

### 🧩 工具扩展 (`YkCoreExtension`)
- **DateTime 扩展**：使用自定义模式格式化时间戳
- **String 扩展**：解析和格式化时间字符串
- **Number 扩展**：将毫秒转换为格式化日期
- **Dynamic 扩展**：复杂对象的深拷贝功能

### 🎨 UI 组件
- **`YkClickWidget`**：带可自定义间隔的防重复点击包装器
- **`YkFutureWidget`**：带标准化加载/空状态的 Future 构建器
- **`YkLoadingWidget`**：带可选文本的一致加载指示器
- **`YkEmptyWidget`**：标准化的空状态显示
- **`YkTextWidget`**：带默认字体族支持的增强 Text 组件

## 安装

在 `pubspec.yaml` 文件中添加：

```yaml
dependencies:
  yk_flutter_core: ^0.0.12
```

然后运行：

```bash
flutter pub get
```

## 使用示例

### 1. 文件管理

```dart
import 'package:yk_flutter_core/yk_file_manager.dart';

// 保存数据到文件
final success = await YkFileManager.save(
  bytes: 'Hello World'.codeUnits,
  filePath: '/path/to/file.txt'
);

// 读取文件数据
final data = await YkFileManager.getData(path: '/path/to/file.txt');

// 检查文件是否存在
final exists = await YkFileManager.exists(path: '/path/to/file.txt');
```

### 2. 权限处理

```dart
import 'package:yk_flutter_core/yk_permission.dart';

// 请求相机权限
final hasCameraPermission = await YkPermission.check(
  type: YkPermissionType.camera,
  onDenied: (openSettings) async {
    // 处理权限拒绝
    await openSettings();
    return false;
  }
);
```

### 3. 动作管理

```dart
import 'package:yk_flutter_core/yk_action_manager.dart';

// 注册动作
YkActionManager.instance.registerCodeAction('my_action', (data) async {
  // 处理动作逻辑
  return 'result';
});

// 执行动作
final result = await YkActionManager.instance.executeAction('my_action', {'param': 'value'});
```

### 4. 日志记录

```dart
import 'package:yk_flutter_core/yk_log.dart';

// 初始化自定义日志
YkLog.init(delegate: MyCustomLogDelegate());

// 使用日志
await YkLog.log(msg: '应用已启动');
await YkLog.error(msg: '发生错误');
```

### 5. 数字日志

```dart
import 'package:yk_flutter_core/yk_dig_log_util.dart';

// 设置数字日志
await YkDigLogUtil.setup(
  delegate: YkDigLogUtilDelegate(
    setup: () async { /* 初始化 */ },
    uploadCallBack: (data) async { /* 上传逻辑 */ return true; },
    saveDocumentPath: () async => '/path/to/logs',
    handleData: (event, title, params) async => '格式化日志条目',
  )
);

// 添加日志条目
YkDigLogUtil.addLog(
  event: 'user_action',
  title: '按钮点击',
  params: {'button_id': 'submit'}
);

// 归档并上传日志
await YkDigLogUtil.archiveAndUpload();
```

### 6. 通知中心

```dart
import 'package:yk_flutter_core/yk_notification_center.dart';

// 发送通知
YKNotificationCenter.instance.post(
  'user_logged_in',
  object: user,
  userInfo: {'timestamp': DateTime.now()}
);

// 监听通知
final subscription = YKNotificationCenter.instance.addObserver(
  'user_logged_in',
  (notification) {
    // 处理通知
    print('用户已登录: ${notification.object}');
  }
);
```

### 7. UI 组件

```dart
import 'package:yk_flutter_core/yk_widget.dart';

// 防重复点击按钮
YkClickWidget(
  onTap: () => print('按钮已点击'),
  child: Text('点击我'),
)

// 带加载状态的 Future 组件
YkFutureWidget<String>(
  initFuture: fetchData(),
  widgetBuilder: (context, data) => Text(data),
)

// 加载指示器
YkLoadingWidget(text: '正在加载数据...')

// 空状态
YkEmptyWidget(text: '无可用数据')
```

### 8. 扩展方法

```dart
import 'package:yk_flutter_core/yk_core_extension.dart';

// 格式化时间戳
final formattedTime = 1640995200000.formatTime(); // "2022-01-01 00:00:00"

// 解析字符串时间戳
final timeFromStr = '1640995200000'.formatTime();

// 深拷贝对象
final copiedObject = originalObject.deepCopy();
```

## 架构

该库遵循**模块化架构**，具有以下关键原则：

1. **单例模式**：核心管理器（`YkActionManager`、`YkDigLogUtil`、`YKNotificationCenter`、`YkLog`）使用单例模式确保一致的全局访问
2. **委托模式**：日志和数字日志使用委托进行自定义而无需继承
3. **扩展方法**：实用函数作为 Dart 扩展提供，实现简洁、链式的语法
4. **平台感知**：所有文件操作包含 `kIsWeb` 检查以确保 Web 兼容性
5. **错误处理**：全面的错误处理，带有开发者日志和可选回调
6. **类型安全**：在适当的地方使用强类型、枚举和泛型

## 核心组件概览

| 组件 | 用途 | 关键特性 |
|-----------|---------|--------------|
| `YkFileManager` | 文件操作 | 跨平台、递归目录创建、二进制数据处理 |
| `YkPermission` | 权限管理 | SDK 感知、可自定义拒绝处理、统一 API |
| `YkActionManager` | 动作路由 | 代码和应用内动作、错误回调、单例 |
| `YkCoreInfo` | 应用配置 | 颜色、组件、令牌/配置检索 |
| `YkLog` | 基础日志 | 委托模式、调试模式回退 |
| `YkDigLogUtil` | 高级日志 | 文件持久化、轮转、上传回调 |
| `YKNotificationCenter` | 事件系统 | 观察者模式、命名通知、基于流 |
| `YkCoreExtension` | 实用方法 | 时间格式化、深拷贝、类型扩展 |

## 最佳实践

1. **尽早初始化**：在应用主函数中设置日志委托和数字日志
2. **优雅处理权限**：始终提供用户友好的拒绝处理
3. **使用标准组件**：利用 `YkFutureWidget` 实现一致的加载状态
4. **利用扩展**：使用提供的扩展方法编写更简洁的代码
5. **集中化动作**：通过 `YkActionManager` 注册所有应用动作以提高可维护性

## 贡献

欢迎贡献！请遵循以下指南：

1. Fork 仓库
2. 创建功能分支
3. 为新功能编写测试
4. 确保代码遵循现有样式模式
5. 提交带有清晰描述的 pull request

## 版本历史

详见 [CHANGELOG.md](CHANGELOG.md) 获取详细版本信息。

## 许可证

本项目基于 MIT 许可证 - 详情见 [LICENSE](LICENSE) 文件。

---

**注意**：此库设计轻量且专注于核心功能。它能很好地与其他 Flutter 包集成，并可根据特定项目需求轻松扩展或自定义。