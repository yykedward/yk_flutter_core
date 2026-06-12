import 'package:flutter_test/flutter_test.dart';
import 'package:yk_flutter_core/yk_flutter_core.dart';

void main() {
  late YkActionManager manager;

  setUp(() {
    manager = YkActionManager.instance;
  });

  group('YkActionManager code actions', () {
    test('registerCodeAction and executeAction', () async {
      manager.registerCodeAction('test_code', (content) async {
        return 'result_$content';
      });

      final result = await manager.executeAction('test_code', 'hello');
      expect(result, 'result_hello');
    });

    test('executeAction calls onError for unknown action', () async {
      String? errorMsg;
      manager.onError = (error) async {
        errorMsg = error;
      };

      final result = await manager.executeAction('unknown_code', null);

      expect(result, isNull);
      expect(errorMsg, isNotNull);
    });

    test('executeAction returns null when no error callback set', () async {
      manager.onError = null;
      final result = await manager.executeAction('unknown_code', null);
      expect(result, isNull);
    });
  });

  group('YkActionManager inApp actions', () {
    test('registerInAppAction and executeInAppAction', () async {
      manager.registerInAppAction('global', 'func', (data) async {
        return 'handled_$data';
      });

      final result = await manager.executeInAppAction('global', 'func', 'payload');
      expect(result, 'handled_payload');
    });

    test('executeInAppAction returns null for empty globalType', () async {
      final result = await manager.executeInAppAction('', 'func', null);
      expect(result, isNull);
    });

    test('executeInAppAction returns null for unknown action', () async {
      String? errorMsg;
      manager.onError = (error) async {
        errorMsg = error;
      };

      final result = await manager.executeInAppAction('unknown', 'action', null);

      expect(result, isNull);
      expect(errorMsg, isNotNull);
    });
  });
}
