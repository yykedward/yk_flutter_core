import 'package:intl/intl.dart';
import 'dart:convert';

extension YKIntCoreExtension on num {
  String formatTime({String formatPattern = "yyyy-MM-dd HH:mm:ss"}) =>
      DateTime.fromMillisecondsSinceEpoch(toInt()).formatTime(formatPattern: formatPattern);
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

extension YkExtensionDateTime on DateTime {
  String formatTime({String formatPattern = "yyyy-MM-dd HH:mm:ss"}) => DateFormat(formatPattern).format(this);
}

extension YkDynamicExtension on dynamic {
  dynamic deepCopy() {
    if (this is Map || this is List) {
      return json.decode(json.encode(this));
    } else if (this is String) {
      String newValue = this;
      return newValue;
    }
    return null;
  }
}
