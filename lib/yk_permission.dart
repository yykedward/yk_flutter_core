import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

enum YkPermissionType {
  mic,
  camera,
  photo,
  notification,
  file,
}

class YkPermission {

  static Future<bool> check({required YkPermissionType type, bool didRequestWhenNoDe = true, Future<bool> Function(Future<bool> Function() openSetting)? deniedCallBack}) async {

    var isGrant = false;

    Permission? permission;

    if (type == YkPermissionType.mic) {
      permission = Permission.microphone;
    } else if (type == YkPermissionType.camera) {
      permission = Permission.camera;
    } else if (type == YkPermissionType.file) {
      permission = Permission.storage;
    } else if (type == YkPermissionType.photo) {
      permission = Permission.photos;
      if (Platform.isAndroid) {
        var sdkVersion = await DeviceInfoPlugin().androidInfo.then((value) => value.version).then((value) => value.sdkInt);
        if (sdkVersion < 33) {
          permission = Permission.storage;
        }
      }
    } else if (type == YkPermissionType.notification) {
      permission = Permission.notification;
    }

    if (permission == null) {
      isGrant = false;
    } else {
      PermissionStatus status = await permission.status;
      if (status.isGranted || status.isLimited) {
        isGrant = true;
      } else {
        if (didRequestWhenNoDe) {
          PermissionStatus status = await permission.request();
          if (status.isPermanentlyDenied || status.isDenied) {
            isGrant = await deniedCallBack?.call(() {
              return openAppSettings();
            }) ?? false;
          } else if (status.isGranted || status.isLimited) {
            if (type == YkPermissionType.photo) {
              isGrant = (status == PermissionStatus.granted || status == PermissionStatus.limited);
            } else {
              isGrant = (status == PermissionStatus.granted);
            }
          }
        } else {
          isGrant = false;
        }
      }
    }

    return isGrant;
  }

}
