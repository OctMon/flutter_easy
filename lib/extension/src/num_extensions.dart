import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_easy/flutter_easy.dart';

extension NumExtensions on num {
  double get adaptRatio => adaptDp(this);

  /// Example:
  /// ```
  /// logWTF("""1:15:00.000000
  /// ${60.minutes + 60.seconds * 15}
  /// ${1.hours + 60000.milliseconds * 15}
  /// ${1.hours + 15.minutes}
  /// ${1.25.hours}""");
  ///```
  Duration get milliseconds => Duration(
      microseconds: (this * Duration.microsecondsPerMillisecond).round());

  Duration get seconds =>
      Duration(milliseconds: (this * Duration.millisecondsPerSecond).round());

  Duration get minutes =>
      Duration(seconds: (this * Duration.secondsPerMinute).round());

  Duration get hours =>
      Duration(minutes: (this * Duration.minutesPerHour).round());

  Duration get days => Duration(hours: (this * Duration.hoursPerDay).round());

  /// Example:
  /// ```
  /// print('📣 wait for 2.5 seconds');
  /// await 2.5.delay();
  /// print('✅ 2.5 seconds completed');
  /// print('📣 callback in 1.8 seconds');
  /// 1.8.delay(() => print('✅ 1.8 seconds callback called'));
  /// print('🎉 currently running callback');
  ///```
  Future delay([FutureOr callback()?]) async => this.seconds.delay(callback);
}

extension IntExtensions on int {
  Color get hexColor => Color(this);
}

extension DoubleExtensions on double {
  /// 显示价格、权重等需要精确小数的情况
  /// Examples:
  /// ```dart
  /// double num1 = 123.45000;
  /// double num2 = 100.00;
  /// double num3 = 99.999;
  /// double num4 = 12.0;
  ///
  /// print(num1.awesome());  // 输出: "123.45"
  /// print(num2.awesome());  // 输出: "100"
  /// print(num3.awesome(3)); // 输出: "99.999"
  /// print(num4.awesome());  // 输出: "12"
  /// ```
  String awesome([int fractionDigits = 2]) {
    String s = toStringAsFixed(fractionDigits);
    while (s.endsWith("0") && s.contains(".")) {
      s = s.substring(0, s.length - 1);
    }
    if (s.endsWith(".")) s = s.substring(0, s.length - 1);
    return s;
  }
}

extension TimeExtensions on num {
  String _toTime(bool all) {
    if (this > 0 && this < 60) {
      final sec = "$this".padLeft(2, '0');
      return "${all ? "00:" : ""}00:$sec";
    }
    if (this >= 60 && this < 3600) {
      final min = "${this ~/ 60}".padLeft(2, '0');
      final sec = "${this % 60}".padLeft(2, '0');
      return "${all ? "00:" : ""}$min:$sec";
    }
    if (this >= 3600) {
      final hours = "${this ~/ 3600}".padLeft(2, '0');
      final min = "${(this % 3600) ~/ 60}".padLeft(2, '0');
      final sec = "${this % 60}".padLeft(2, '0');
      return "$hours:$min:$sec";
    }
    return "${all ? "00:" : ""}00:00";
  }

  String get toFullTimeStyle {
    return _toTime(true);
  }

  String get toTimeStyle {
    return _toTime(false);
  }
}
