import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:yk_flutter_core/yk_log.dart';

extension YKIntCoreExtension on num {
  String formatTime({String formatPattern = "yyyy-MM-dd HH:mm:ss"}) =>
      DateTime.fromMillisecondsSinceEpoch(toInt())
          .formatTime(formatPattern: formatPattern);

  double get l => toDouble();
}

extension YkExtensionString on String {
  String? formatTime({String formatPattern = "yyyy-MM-dd HH:mm:ss"}) {
    try {
      int time = int.parse(this);
      return time.formatTime(formatPattern: formatPattern);
    } catch (e) {
      YkLog.log(msg: e.toString());
      return null;
    }
  }
}

extension YkExtensionDateTime on DateTime {
  String formatTime({String formatPattern = "yyyy-MM-dd HH:mm:ss"}) =>
      DateFormat(formatPattern).format(this);
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
