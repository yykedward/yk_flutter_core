import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// 文件管理工具类
class YkFileManager {
  /// 私有构造函数，防止实例化
  YkFileManager._();

  /// 获取应用程序文档目录路径
  ///
  /// 返回文档目录的路径字符串，如果获取失败则返回空字符串
  static Future<String> getDocumentPath() async {
    if (kIsWeb) {
      return "";
    }
    try {
      if (Platform.isAndroid) {
        final directory = await getExternalStorageDirectory();
        return directory?.path ?? '';
      } else if (Platform.isIOS) {
        final directory = await getApplicationDocumentsDirectory();
        return directory.path;
      }
      return '';
    } catch (e) {
      developer.log('获取文档路径失败: $e');
      return '';
    }
  }

  /// 创建目录
  ///
  /// [path] 要创建的目录路径
  /// 返回是否创建成功
  static Future<bool> createPath({required String path}) async {
    if (path.isEmpty || kIsWeb) {
      return false;
    }

    try {
      final dir = Directory(path);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      return true;
    } catch (e) {
      developer.log('创建目录失败: $e');
      return false;
    }
  }

  /// 保存文件
  ///
  /// [bytes] 要保存的字节数据
  /// [filePath] 文件保存路径
  /// 返回是否保存成功
  static Future<bool> save({
    required List<int> bytes,
    required String filePath,
  }) async {
    if (bytes.isEmpty || filePath.isEmpty || kIsWeb) {
      return false;
    }

    try {
      final fileName = path.basename(filePath);
      final dirPath = filePath.replaceAll(fileName, '');

      // 确保目录存在
      final pathCreated = await createPath(path: dirPath);
      if (!pathCreated) {
        return false;
      }

      final file = File(filePath);
      await file.writeAsBytes(bytes, flush: true);
      return true;
    } catch (e) {
      developer.log('保存文件失败: $e');
      return false;
    }
  }

  /// 读取文件数据
  ///
  /// [path] 文件路径
  /// 返回文件的字节数据，如果读取失败则返回null
  static Future<List<int>?> getData({required String path}) async {
    if (path.isEmpty || kIsWeb) {
      return null;
    }

    try {
      final file = File(path);
      if (await file.exists()) {
        return await file.readAsBytes();
      }
      return null;
    } catch (e) {
      developer.log('读取文件失败: $e');
      return null;
    }
  }

  /// 删除文件
  ///
  /// [path] 要删除的文件路径
  /// 返回是否删除成功
  static Future<bool> deleteFile({required String path}) async {
    if (path.isEmpty || kIsWeb) {
      return false;
    }

    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      developer.log('删除文件失败: $e');
      return false;
    }
  }

  /// 检查文件是否存在
  ///
  /// [path] 文件路径
  /// 返回文件是否存在
  static Future<bool> exists({required String path}) async {
    if (path.isEmpty || kIsWeb) {
      return false;
    }

    try {
      return await File(path).exists();
    } catch (e) {
      developer.log('检查文件是否存在失败: $e');
      return false;
    }
  }
}
