import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class YkFileManager {

  static Future<String> getDocumentPath() async {
    var documentPath = "";
    if (Platform.isAndroid) {
      documentPath = (await getExternalStorageDirectory())?.path ?? "";
    } else if (Platform.isIOS) {
      documentPath = (await getApplicationDocumentsDirectory()).path;
    }
    return documentPath;
  }

  static Future<bool> creatPath({required String path}) async {
    try {
      final dir = Directory(path);

      if (!dir.existsSync()) {
        await dir.create();
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> save({required List<int> bytes, required String filePath}) async {

    try {

      String fileNameBase = path.basename(filePath);

      String fileDirPath = filePath.replaceAll(fileNameBase, "");

      final createPath = await YkFileManager.creatPath(path: fileDirPath);
      if (!createPath) {
        return false;
      }

      final file = File(filePath);

      if (!file.existsSync()) {
        final created = await file.create();

        await created.writeAsBytes(bytes);
      } else {
        await file.writeAsBytes(bytes);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<List<int>?> getData({required String path}) async {

    try {
      final docFile = File(path);
      final docFileEx = await docFile.exists();

      if (docFileEx) {
        return docFile.readAsBytes();
      } else {
        return null;
      }

    } catch (e) {
      return null;
    }
  }
}
