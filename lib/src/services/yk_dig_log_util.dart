import 'package:flutter/foundation.dart';
import 'package:yk_flutter_core/src/services/yk_log_writer.dart';

class _LogData {
  final String event;
  final String title;
  final dynamic params;

  _LogData({
    required this.event,
    required this.title,
    required this.params,
  });

  Map<String, dynamic> toJson() => {
        'event': event,
        'title': title,
        'params': params,
      };
}

class YkDigLogUtilDelegate {
  final Future<void> Function() setup;
  final Future<bool> Function(String data) uploadCallBack;
  final Future<String> Function() saveDocumentPath;
  final Future<String> Function(String event, String title, dynamic params)? handleData;
  final void Function(dynamic data)? logCallBack;

  const YkDigLogUtilDelegate({
    required this.setup,
    required this.uploadCallBack,
    required this.saveDocumentPath,
    this.handleData,
    this.logCallBack,
  });
}

class YkDigLogUtil {
  static final YkDigLogUtil instance = YkDigLogUtil._();

  YkDigLogUtil._();

  YkDigLogUtilDelegate? _delegate;
  YkLogWriter? _writer;
  String _currentFileName = '';
  bool _isWriting = false;
  final List<String> _logQueue = [];

  static int maxFileSize = 1024 * 5;

  static Future<void> setup({required YkDigLogUtilDelegate delegate}) async {
    instance._delegate = delegate;
    instance._writer = YkLogWriter(
      saveDocumentPath: () => delegate.saveDocumentPath(),
      uploadCallback: (data) => delegate.uploadCallBack(data),
      logCallback: delegate.logCallBack,
      maxFileSize: maxFileSize,
    );
    return delegate.setup();
  }

  static void addLog({
    required String event,
    required String title,
    required dynamic params,
  }) {
    instance._addLogEntry(event: event, title: title, params: params);
  }

  static Future<void> archiveAndUpload() async {
    await instance._writer?.archiveAndUpload();
  }

  Future<void> _addLogEntry({
    required String event,
    required String title,
    required dynamic params,
  }) async {
    if (kIsWeb) {
      return;
    }
    final logData = await _delegate?.handleData?.call(event, title, params) ?? '';

    _logQueue.add(logData);

    _delegate?.logCallBack?.call(_LogData(
      event: event,
      title: title,
      params: params,
    ).toJson());

    await _processLogQueue();
  }

  Future<void> _processLogQueue() async {
    if (_logQueue.isEmpty || _isWriting) return;

    _isWriting = true;
    try {
      final entry = _logQueue.removeAt(0);
      await _writeLogToFile(entry);
    } finally {
      _isWriting = false;
      if (_logQueue.isNotEmpty) {
        await _processLogQueue();
      }
    }
  }

  Future<void> _writeLogToFile(String logEntry) async {
    if (_currentFileName.isEmpty) {
      _currentFileName = DateTime.now().millisecondsSinceEpoch.toString();
    }

    final writer = _writer;
    if (writer == null) return;

    final file = await writer.getLogFile(_currentFileName);
    if (file == null) {
      _logQueue.insert(0, logEntry);
      return;
    }

    final belowLimit = await writer.writeEntry(file, logEntry);
    if (!belowLimit) {
      await writer.rotateFile(file);
      _currentFileName = '';
    }
  }
}
