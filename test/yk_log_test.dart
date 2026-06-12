import 'package:flutter_test/flutter_test.dart';
import 'package:yk_flutter_core/yk_flutter_core.dart';

class _TestLogDelegate with YkLogDelegate {
  final List<String> logMessages = [];
  final List<String> errorMessages = [];

  @override
  Future log(String msg) async {
    logMessages.add(msg);
  }

  @override
  Future error(String msg) async {
    errorMessages.add(msg);
  }
}

void main() {
  group('YkLog', () {
    test('delegate receives log messages', () async {
      final delegate = _TestLogDelegate();
      YkLog.init(delegate: delegate);

      await YkLog.log(msg: 'test message');

      expect(delegate.logMessages, contains('test message'));
    });

    test('delegate receives error messages', () async {
      final delegate = _TestLogDelegate();
      YkLog.init(delegate: delegate);

      await YkLog.error(msg: 'error message');

      expect(delegate.errorMessages, contains('error message'));
    });

    test('multiple log calls are all received', () async {
      final delegate = _TestLogDelegate();
      YkLog.init(delegate: delegate);

      await YkLog.log(msg: 'first');
      await YkLog.log(msg: 'second');
      await YkLog.error(msg: 'third');

      expect(delegate.logMessages.length, 2);
      expect(delegate.errorMessages.length, 1);
    });
  });
}
