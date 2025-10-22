import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

/// 权限类型枚举
enum YkPermissionType {
  mic,
  camera,
  photo,
  notification,
  file,
}

class YkPermission {



  /// 检查并请求权限
  /// [type] 权限类型
  /// [requestIfDenied] 是否在未授权时自动请求
  /// [onDenied] 拒绝时的回调，参数为打开设置页的方法
  static Future<bool> check({
    required YkPermissionType type,
    bool requestIfDenied = true,
    Future<bool> Function(Future<bool> Function() openSetting)? onDenied,
  }) async {
    Permission? permission;

    switch (type) {
      case YkPermissionType.mic:
        permission = Permission.microphone;
        break;
      case YkPermissionType.camera:
        permission = Permission.camera;
        break;
      case YkPermissionType.file:
        permission = Permission.storage;
        break;
      case YkPermissionType.photo:
        if (Platform.isAndroid) {
          final androidInfo = await DeviceInfoPlugin().androidInfo;
          if (androidInfo.version.sdkInt < 33) {
            permission = Permission.storage;
          } else {
            permission = Permission.photos;
          }
        } else {
          permission = Permission.photos;
        }
        break;
      case YkPermissionType.notification:
        permission = Permission.notification;
        break;
    }

    PermissionStatus status = await permission.status;
    if (status.isGranted || status.isLimited) {
      return true;
    }

    if (requestIfDenied) {
      status = await permission.request();
      if (status.isPermanentlyDenied || status.isDenied) {
        // 拒绝时回调
        if (onDenied != null) {
          return await onDenied(() => openAppSettings());
        }
        return false;
      } else if (status.isGranted || status.isLimited) {
        if (type == YkPermissionType.photo) {
          return status == PermissionStatus.granted || status == PermissionStatus.limited;
        } else {
          return status == PermissionStatus.granted;
        }
      }
    }

    return false;
  }
}
