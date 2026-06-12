import 'package:flutter_test/flutter_test.dart';
import 'package:yk_flutter_core/yk_flutter_core.dart';

void main() {
  late YkNotificationCenter center;

  setUp(() {
    center = YkNotificationCenter.instance;
  });

  group('YkNotificationCenter', () {
    test('post and receive notification', () async {
      dynamic receivedObject;
      Map<String, dynamic>? receivedUserInfo;

      center.addObserver('test_event', (notification) {
        receivedObject = notification.object;
        receivedUserInfo = notification.userInfo;
      });

      center.post('test_event',
        object: 'hello',
        userInfo: {'key': 'value'},
      );

      // Stream is synchronous for broadcast controllers
      await Future.delayed(Duration.zero);

      expect(receivedObject, 'hello');
      expect(receivedUserInfo, {'key': 'value'});
    });

    test('observer only receives matching notification name', () async {
      int callCount = 0;

      center.addObserver('event_a', (notification) {
        callCount++;
      });

      center.post('event_b', object: 'data');

      await Future.delayed(Duration.zero);

      expect(callCount, 0);
    });

    test('multiple observers receive same notification', () async {
      int countA = 0;
      int countB = 0;

      center.addObserver('shared_event', (_) => countA++);
      center.addObserver('shared_event', (_) => countB++);

      center.post('shared_event');

      await Future.delayed(Duration.zero);

      expect(countA, 1);
      expect(countB, 1);
    });

    test('post without object or userInfo works', () async {
      bool received = false;

      center.addObserver('bare_event', (notification) {
        received = true;
        expect(notification.object, isNull);
        expect(notification.userInfo, isNull);
      });

      center.post('bare_event');

      await Future.delayed(Duration.zero);

      expect(received, isTrue);
    });

    test('dispose prevents further notifications', () async {
      int count = 0;

      center.addObserver('pre_dispose', (_) => count++);

      center.post('pre_dispose');
      await Future.delayed(Duration.zero);
      expect(count, 1);

      center.dispose();

      // Posting after dispose will throw since the stream is closed
      expect(
        () => center.post('pre_dispose'),
        throwsA(isA<StateError>()),
      );
    });
  });
}
