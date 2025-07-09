import 'package:intl/intl.dart';

extension YKIntCoreExtension on int {
  String formatTime({String formatPattern = "yyyy-MM-dd HH:mm:ss"}) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(this);
    final dateFormat = DateFormat(formatPattern);
    final dateStr = dateFormat.format(dateTime);
    return dateStr;
  }
}

extension YkExtensionString on String {
  String formatTime({String formatPattern = "yyyy-MM-dd HH:mm:ss"}) {
    try {
      int time = int.parse(this);
      return time.formatTime(formatPattern: formatPattern);
    } catch (e) {
      return "";
    }
  }
}
