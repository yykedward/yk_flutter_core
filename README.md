# yk_flutter_core

A comprehensive Flutter core utility library that provides essential tools and components to streamline mobile application development. This package offers file management, permission handling, action management, logging, notification systems, and reusable UI widgets.

[English Version](README.md) | [中文版本](README_zh.md)

## Features

### 📁 File Management (`YkFileManager`)
- Cross-platform file operations (Android/iOS)
- Get document storage paths
- Create directories recursively
- Save binary data to files
- Read file contents as bytes
- Delete files and check existence
- Web platform compatibility checks

### 🔒 Permission Management (`YkPermission`)
- Unified permission handling for common use cases
- Supports microphone, camera, photo gallery, notifications, and storage
- Android SDK version-aware photo permission handling
- Customizable denial callbacks with settings navigation
- Automatic permission request flow

### 🎯 Action Management (`YkActionManager`)
- Centralized action registration and execution system
- Supports both code-based and in-app behavior patterns
- Global and function-type action categorization
- Error handling with custom error callbacks
- Singleton pattern for consistent access

### 📊 Core Information (`YkCoreInfo`)
- Centralized app configuration and styling
- Predefined color schemes and UI constants
- Standardized loading and empty state widgets
- Core token and configuration retrieval utilities
- Consistent theming across applications

### 📝 Logging System (`YkLog`)
- Flexible logging with delegate pattern
- Debug mode console output fallback
- Custom log implementation support
- Error and info logging separation
- Easy integration with external logging services

### 📈 Digital Logging (`YkDigLogUtil`)
- Advanced logging with file persistence
- Automatic log rotation and archiving
- Upload callback system for remote logging
- Configurable file size limits (default 5KB)
- Queue-based asynchronous writing
- Web platform compatibility

### 🔔 Notification Center (`YKNotificationCenter`)
- Observer pattern implementation for event broadcasting
- Named notifications with optional data payload
- UserInfo dictionary support for additional context
- Stream-based subscription system
- Memory-efficient broadcast architecture

### 🧩 Utility Extensions (`YkCoreExtension`)
- **DateTime extensions**: Format timestamps with custom patterns
- **String extensions**: Parse and format time strings
- **Number extensions**: Convert milliseconds to formatted dates
- **Dynamic extensions**: Deep copy functionality for complex objects

### 🎨 UI Widgets
- **`YkClickWidget`**: Anti-double-click wrapper with customizable intervals
- **`YkFutureWidget`**: Future builder with standardized loading/empty states
- **`YkLoadingWidget`**: Consistent loading indicator with optional text
- **`YkEmptyWidget`**: Standardized empty state display
- **`YkTextWidget`**: Enhanced Text widget with default font family support

## Installation

Add this to your `pubspec.yaml` file:

```yaml
dependencies:
  yk_flutter_core: ^0.0.12
```

Then run:

```bash
flutter pub get
```

## Usage Examples

### 1. File Management

```dart
import 'package:yk_flutter_core/yk_file_manager.dart';

// Save data to file
final success = await YkFileManager.save(
  bytes: 'Hello World'.codeUnits,
  filePath: '/path/to/file.txt'
);

// Read file data
final data = await YkFileManager.getData(path: '/path/to/file.txt');

// Check if file exists
final exists = await YkFileManager.exists(path: '/path/to/file.txt');
```

### 2. Permission Handling

```dart
import 'package:yk_flutter_core/yk_permission.dart';

// Request camera permission
final hasCameraPermission = await YkPermission.check(
  type: YkPermissionType.camera,
  onDenied: (openSettings) async {
    // Handle permission denial
    await openSettings();
    return false;
  }
);
```

### 3. Action Management

```dart
import 'package:yk_flutter_core/yk_action_manager.dart';

// Register an action
YkActionManager.instance.registerCodeAction('my_action', (data) async {
  // Handle action logic
  return 'result';
});

// Execute an action
final result = await YkActionManager.instance.executeAction('my_action', {'param': 'value'});
```

### 4. Logging

```dart
import 'package:yk_flutter_core/yk_log.dart';

// Initialize custom logging
YkLog.init(delegate: MyCustomLogDelegate());

// Use logging
await YkLog.log(msg: 'Application started');
await YkLog.error(msg: 'Something went wrong');
```

### 5. Digital Logging

```dart
import 'package:yk_flutter_core/yk_dig_log_util.dart';

// Setup digital logging
await YkDigLogUtil.setup(
  delegate: YkDigLogUtilDelegate(
    setup: () async { /* initialization */ },
    uploadCallBack: (data) async { /* upload logic */ return true; },
    saveDocumentPath: () async => '/path/to/logs',
    handleData: (event, title, params) async => 'formatted log entry',
  )
);

// Add log entries
YkDigLogUtil.addLog(
  event: 'user_action',
  title: 'Button Clicked',
  params: {'button_id': 'submit'}
);

// Archive and upload logs
await YkDigLogUtil.archiveAndUpload();
```

### 6. Notification Center

```dart
import 'package:yk_flutter_core/yk_notification_center.dart';

// Post a notification
YKNotificationCenter.instance.post(
  'user_logged_in',
  object: user,
  userInfo: {'timestamp': DateTime.now()}
);

// Observe notifications
final subscription = YKNotificationCenter.instance.addObserver(
  'user_logged_in',
  (notification) {
    // Handle notification
    print('User logged in: ${notification.object}');
  }
);
```

### 7. UI Widgets

```dart
import 'package:yk_flutter_core/yk_widget.dart';

// Anti-double-click button
YkClickWidget(
  onTap: () => print('Button clicked'),
  child: Text('Click me'),
)

// Future-based widget with loading state
YkFutureWidget<String>(
  initFuture: fetchData(),
  widgetBuilder: (context, data) => Text(data),
)

// Loading indicator
YkLoadingWidget(text: 'Loading data...')

// Empty state
YkEmptyWidget(text: 'No data available')
```

### 8. Extension Methods

```dart
import 'package:yk_flutter_core/yk_core_extension.dart';

// Format timestamp
final formattedTime = 1640995200000.formatTime(); // "2022-01-01 00:00:00"

// Parse string timestamp
final timeFromStr = '1640995200000'.formatTime();

// Deep copy object
final copiedObject = originalObject.deepCopy();
```

## Architecture

The library follows a **modular architecture** with these key principles:

1. **Singleton Pattern**: Core managers (`YkActionManager`, `YkDigLogUtil`, `YKNotificationCenter`, `YkLog`) use singleton patterns for consistent global access
2. **Delegate Pattern**: Logging and digital logging use delegates for customization without inheritance
3. **Extension Methods**: Utility functions are provided as Dart extensions for clean, chainable syntax
4. **Platform Awareness**: All file operations include `kIsWeb` checks for web compatibility
5. **Error Handling**: Comprehensive error handling with developer logging and optional callbacks
6. **Type Safety**: Strong typing with enums and generics where appropriate

## Core Components Overview

| Component | Purpose | Key Features |
|-----------|---------|--------------|
| `YkFileManager` | File operations | Cross-platform, recursive directory creation, binary data handling |
| `YkPermission` | Permission management | SDK-aware, customizable denial handling, unified API |
| `YkActionManager` | Action routing | Code and in-app actions, error callbacks, singleton |
| `YkCoreInfo` | App configuration | Colors, widgets, token/config retrieval |
| `YkLog` | Basic logging | Delegate pattern, debug mode fallback |
| `YkDigLogUtil` | Advanced logging | File persistence, rotation, upload callbacks |
| `YKNotificationCenter` | Event system | Observer pattern, named notifications, stream-based |
| `YkCoreExtension` | Utility methods | Time formatting, deep copying, type extensions |

## Best Practices

1. **Initialize Early**: Set up logging delegates and digital logging in your app's main function
2. **Handle Permissions Gracefully**: Always provide user-friendly denial handling
3. **Use Standard Widgets**: Leverage `YkFutureWidget` for consistent loading states
4. **Leverage Extensions**: Use the provided extension methods for cleaner code
5. **Centralize Actions**: Register all app actions through `YkActionManager` for maintainability

## Contributing

Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch
3. Write tests for new functionality
4. Ensure code follows existing style patterns
5. Submit a pull request with clear description

## Version History

See [CHANGELOG.md](CHANGELOG.md) for detailed version information.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Note**: This library is designed to be lightweight and focused on core functionality. It integrates well with other Flutter packages and can be easily extended or customized for specific project needs.