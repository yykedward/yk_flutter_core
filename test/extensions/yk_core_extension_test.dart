import 'package:flutter_test/flutter_test.dart';
import 'package:yk_flutter_core/yk_flutter_core.dart';

void main() {
  group('num.formatTime', () {
    test('formats milliseconds since epoch to default pattern', () {
      // 2022-01-01 00:00:00 UTC = 1640995200000
      final result = 1640995200000.formatTime();
      expect(result, contains('2022-01-01'));
    });

    test('formats with custom pattern', () {
      final result = 1640995200000.formatTime(formatPattern: 'yyyy/MM/dd');
      expect(result, '2022/01/01');
    });
  });

  group('String.formatTime', () {
    test('parses numeric string and formats', () {
      final result = '1640995200000'.formatTime();
      expect(result, contains('2022-01-01'));
    });

    test('returns null for invalid string', () {
      final result = 'not_a_number'.formatTime();
      expect(result, isNull);
    });
  });

  group('DateTime.formatTime', () {
    test('formats with custom pattern', () {
      final dt = DateTime(2022, 6, 15, 14, 30, 0);
      expect(dt.formatTime(formatPattern: 'yyyy-MM-dd'), '2022-06-15');
      expect(dt.formatTime(formatPattern: 'HH:mm'), '14:30');
    });
  });

  group('deepCopy', () {
    test('deep copies a Map (no shared references)', () {
      final original = {'a': 1, 'b': [2, 3]};
      final copy = original.deepCopy() as Map;
      copy['a'] = 99;
      (copy['b'] as List)[0] = 999;

      expect(original['a'], 1);
      expect((original['b'] as List)[0], 2);
    });

    test('deep copies a List', () {
      final original = [1, {'x': 10}];
      final copy = original.deepCopy() as List;
      copy[0] = 99;
      (copy[1] as Map)['x'] = 999;

      expect(original[0], 1);
      expect((original[1] as Map)['x'], 10);
    });

    test('returns original for non-Map/List types', () {
      expect('hello'.deepCopy(), 'hello');
      expect(42.deepCopy(), 42);
      expect(true.deepCopy(), true);
    });
  });
}
