## 0.0.15

* REFACTOR: restructure lib/ into src/ with modular subdirectories (managers/services/logging/core/extensions/widgets)
* REFACTOR: split YkDigLogUtil - extract YkLogWriter for file I/O concerns
* REFACTOR: rename YKNotificationCenter → YkNotificationCenter for consistent naming
* FIX: add kIsWeb guard to YkPermission.check()
* FIX: await delegate calls in YkLog.log() and YkLog.error()
* FIX: add dispose() to YkNotificationCenter for StreamController cleanup
* FIX: deepCopy() returns original value instead of null for unsupported types
* FIX: replace deprecated textScaleFactor with textScaler in YkTextWidget
* CHORE: remove empty yk_material.dart and unused imports
* TEST: add 30 unit tests covering extensions, managers, logging, and widgets

## 0.0.14

* ADD: YkState abstract class with didDispose lifecycle flag
* REFACTOR: YkClickWidget extends YkState instead of State
* REFACTOR: YkCoreInfo.token and YkCoreInfo.config replace async getCoreToken()/getConfig()
* REMOVE: yk_widget.dart widget barrel file (widgets now imported individually)
* FIX: remove yk_widget.dart export from yk_flutter_core.dart barrel

## 0.0.12

* FEAT: YkFutureWidget add emptyWidget & loadingWidget

## 0.0.12

* FIX: getCoreToken & getConfig
* ADD: YkEmptyWidget

## 0.0.11

* ADD: yk supabase manager
* ADD: yk log

## 0.0.10

* FIX: add text widget

## 0.0.9

* FIX: fix warning

## 0.0.8

* ADD: YkDigLogUtil
* ADD: YKNotificationCenter
* FEAT：change get token action name

## 0.0.7

* ADD: YkClickWidget
* ADD: YkLoadingWidget

## 0.0.6

* FEAT: fix debug target

## 0.0.5

* FIX: all util kIsWeb

## 0.0.4

* FEAT: add YkActionManager and token

## 0.0.3

* FEAT: add YkPermission

## 0.0.2

* FEAT: optimized code

## 0.0.1

* TODO: Add YkFileManager
