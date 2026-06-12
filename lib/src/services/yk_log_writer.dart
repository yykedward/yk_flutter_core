import 'dart:io';

class YkLogWriter {
  static const logExtension = '.log';
  static const archivedExtension = '.archived';
  static const uploadedExtension = '.uploaded';

  final Future<String> Function() saveDocumentPath;
  final Future<bool> Function(String) uploadCallback;
  final void Function(dynamic)? logCallback;
  final int maxFileSize;

  YkLogWriter({
    required this.saveDocumentPath,
    required this.uploadCallback,
    this.logCallback,
    this.maxFileSize = 1024 * 5,
  });

  Future<Directory> _getLogDirectory() async {
    final path = await saveDocumentPath();
    final dir = Directory(path);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<File?> getLogFile(String fileName) async {
    try {
      final dir = await _getLogDirectory();
      return await File('${dir.path}$fileName$logExtension').create();
    } catch (e) {
      logCallback?.call('创建日志文件失败: $e');
      return null;
    }
  }

  Future<bool> writeEntry(File file, String entry) async {
    try {
      await file.writeAsString('$entry\n', mode: FileMode.append);
      return await file.length() <= maxFileSize;
    } catch (e) {
      logCallback?.call('写入日志失败: $e');
      return false;
    }
  }

  Future<void> rotateFile(File file) async {
    try {
      if (await file.exists()) {
        final newPath = file.path.replaceAll(logExtension, archivedExtension);
        await file.rename(newPath);
        await _uploadFile(File(newPath));
      }
    } catch (e) {
      logCallback?.call('归档文件失败: $e');
    }
  }

  Future<void> archiveAndUpload() async {
    final dir = await _getLogDirectory();
    final files = dir.listSync();

    for (final file in files) {
      final path = file.path;
      if (path.endsWith(uploadedExtension)) {
        await file.delete();
        continue;
      }

      if (path.endsWith(logExtension)) {
        final newPath = path.replaceAll(logExtension, archivedExtension);
        final archivedFile = await File(path).rename(newPath);
        await _uploadFile(archivedFile);
      } else if (path.endsWith(archivedExtension)) {
        await _uploadFile(File(path));
      }
    }
  }

  Future<void> _uploadFile(File file) async {
    if (!await file.exists()) return;

    try {
      final content = await file.readAsString();
      logCallback?.call(content);

      final success = await uploadCallback(content);
      if (success) {
        final newPath = file.path.replaceAll(archivedExtension, uploadedExtension);
        await file.rename(newPath);
      }
    } catch (e) {
      logCallback?.call('上传失败: $e');
    }
  }
}
