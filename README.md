

# yk_flutter_core

一个 Flutter 核心功能库，提供常用工具和组件，简化开发流程。

## 功能

- **YkFileManager**
  - 获取存储路径
  - 保存内容（需先将内容转换为二进制数据）
  - 读取内容（根据路径获取数据）

## 安装

在 `pubspec.yaml` 中添加：

```yaml
dependencies:
  yk_flutter_core: ^0.0.6
```

然后运行：

```bash
flutter pub get
```

## 使用示例

### 使用文件管理器保存和读取数据

```dart
import 'package:yk_flutter_core/yk_file_manager.dart';

void exampleUsage() async {
  final data = '示例内容'.codeUnits; // 转换为二进制数据
  final success = await YkFileManager.saveData(data, 'example.txt');
  if (success) {
    final content = await YkFileManager.getData('example.txt');
    print('文件内容: $content');
  } else {
    print('保存失败');
  }
}
```

## 贡献

欢迎提交 issue 和 PR！请遵循项目的代码规范和结构。

## 版本历史

查看 [CHANGELOG.md](CHANGELOG.md) 获取完整的版本更新信息。

## 许可证

本项目基于 MIT 许可证，详见 [LICENSE](LICENSE) 文件。