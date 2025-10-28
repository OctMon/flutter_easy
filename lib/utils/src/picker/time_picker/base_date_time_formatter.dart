import 'dart:math';

import 'package:intl/intl.dart';

import 'base_date_picker_constants.dart';
import 'date_picker/base_date_picker.dart';
import 'date_range_picker/base_date_range_picker.dart';

const String DATE_FORMAT_SEPARATOR = r'[|,-\._: ]+';

class DateTimeFormatter {
  static DateTime? convertStringToDate(String? format, String? date) {
    if (format == null || format.isEmpty || date == null || date.isEmpty)
      return null;

    return DateFormat(format).parse(date);
  }

  static DateTime? convertIntValueToDateTime(String? value) {
    if (value == null) {
      return null;
    } else {
      return int.tryParse(value) != null
          ? DateTime.fromMillisecondsSinceEpoch(int.tryParse(value)!)
          : null;
    }
  }

  /// Get default value of date format.
  static String generateDateFormat(
      String? dateFormat, BaseDateTimePickerMode pickerMode) {
    if (dateFormat != null && dateFormat.isNotEmpty) {
      return dateFormat;
    }
    switch (pickerMode) {
      case BaseDateTimePickerMode.date:
        return datetimePickerDateFormat;
      case BaseDateTimePickerMode.time:
        return datetimePickerTimeFormat;
      case BaseDateTimePickerMode.datetime:
        return datetimePickerDatetimeFormat;
    }
  }

  static String generateDateRangePickerFormat(
      String? dateFormat, BaseDateTimeRangePickerMode pickerMode) {
    if (dateFormat != null && dateFormat.isNotEmpty) {
      return dateFormat;
    }
    switch (pickerMode) {
      case BaseDateTimeRangePickerMode.date:
        return datetimeRangePickerDateFormat;
      case BaseDateTimeRangePickerMode.time:
        return datetimeRangePickerTimeFormat;
    }
  }

  /// Check if the date format is for day(contain y、M、d、E) or not.
  static bool isDayFormat(String format) {
    return format.contains(RegExp(r'[yMdE]'));
  }

  /// Check if the date format is for time(contain H、m、s) or not.
  static bool isTimeFormat(String format) {
    return format.contains(RegExp(r'[Hms]'));
  }

  /// Split date format to array.
  static List<String> splitDateFormat(String? dateFormat,
      {BaseDateTimePickerMode? mode}) {
    if (dateFormat == null || dateFormat.isEmpty) {
      return [];
    }
    List<String> result = dateFormat.split(RegExp(DATE_FORMAT_SEPARATOR));
    if (mode == BaseDateTimePickerMode.datetime) {
      // datetime mode need join day format
      List<String> temp = [];
      StringBuffer dayFormat = StringBuffer();
      for (int i = 0; i < result.length; i++) {
        String format = result[i];
        if (isDayFormat(format)) {
          // find format pre-separator
          int end = dateFormat.indexOf(format);
          if (end > 0) {
            int start = 0;
            if (i > 0) {
              start = dateFormat.indexOf(result[i - 1]) + result[i - 1].length;
            }
            dayFormat.write(dateFormat.substring(start, end));
          }
          dayFormat.write(format);
        } else if (isTimeFormat(format)) {
          temp.add(format);
        }
      }
      if (dayFormat.length > 0) {
        temp.insert(0, dayFormat.toString());
      } else {
        // add default date format
        temp.insert(0, datetimePickerDateFormat);
      }
      result = temp;
    }
    return result;
  }

  /// Format datetime string
  static String formatDateTime(int value, String format) {
    if (format.isEmpty) {
      return value.toString();
    }

    String result = format;
    // format year text
    if (format.contains('y')) {
      result = _formatYear(value, result);
    }
    // format month text
    if (format.contains('M')) {
      result = _formatMonth(value, result);
    }
    // format day text
    if (format.contains('d')) {
      result = _formatDay(value, result);
    }
    if (format.contains('E')) {
      result = _formatWeek(value, result);
    }
    // format hour text
    if (format.contains('H')) {
      result = _formatHour(value, result);
    }
    // format minute text
    if (format.contains('m')) {
      result = _formatMinute(value, result);
    }
    // format second text
    if (format.contains('s')) {
      result = _formatSecond(value, result);
    }
    if (result == format) {
      return value.toString();
    }
    return result;
  }

  /// Format day display
  static String formatDate(DateTime dateTime, String format) {
    if (format.isEmpty) {
      return dateTime.toString();
    }

    String result = format;
    // format year text
    if (format.contains('y')) {
      result = _formatYear(dateTime.year, result);
    }
    // format month text
    if (format.contains('M')) {
      result = _formatMonth(dateTime.month, result);
    }
    // format day text
    if (format.contains('d')) {
      result = _formatDay(dateTime.day, result);
    }
    if (format.contains('E')) {
      result = _formatWeek(dateTime.weekday, result);
    }
    if (result == format) {
      return dateTime.toString();
    }
    return result;
  }

  /// format year text
  static String _formatYear(int value, String format) {
    if (format.contains('yyyy')) {
      // yyyy: the digit count of year is 4, e.g. 2019
      return format.replaceAll('yyyy', value.toString());
    } else if (format.contains('yy')) {
      // yy: the digit count of year is 2, e.g. 19
      return format.replaceAll('yy',
          value.toString().substring(max(0, value.toString().length - 2)));
    }
    return value.toString();
  }

  /// format month text
  static String _formatMonth(int value, String format) {
    List<String> months = monthsName;
    if (format.contains('MMMM')) {
      // MMMM: the full name of month, e.g. January
      return format.replaceAll('MMMM', months[value - 1]);
    } else if (format.contains('MMM')) {
      // MMM: the short name of month, e.g. Jan
      String month = months[value - 1];
      return format.replaceAll('MMM', month.substring(0, min(3, month.length)));
    }
    return _formatNumber(value, format, 'M');
  }

  /// format day text
  static String _formatDay(int value, String format) {
    return _formatNumber(value, format, 'd');
  }

  /// format week text
  static String _formatWeek(int value, String format) {
    if (format.contains('EEEE')) {
      // EEEE: the full name of week, e.g. Monday
      List<String> weeks = weekFullName;
      return format.replaceAll('EEEE', weeks[value - 1]);
    }
    // EEE: the short name of week, e.g. Mon
    List<String> weeks = weekShortName;
    return format.replaceAll(RegExp(r'E+'), weeks[value - 1]);
  }

  /// format hour text
  static String _formatHour(int value, String format) {
    return _formatNumber(value, format, 'H');
  }

  /// format minute text
  static String _formatMinute(int value, String format) {
    return _formatNumber(value, format, 'm');
  }

  /// format second text
  static String _formatSecond(int value, String format) {
    return _formatNumber(value, format, 's');
  }

  /// format number, if the digit count is 2, will pad zero on the left
  static String _formatNumber(int value, String format, String unit) {
    if (format.contains('$unit$unit')) {
      return format.replaceAll('$unit$unit', value.toString().padLeft(2, '0'));
    } else if (format.contains('$unit')) {
      return format.replaceAll('$unit', value.toString());
    }
    return value.toString();
  }

  static List<String> get monthsName => [
        '01',
        '02',
        '03',
        '04',
        '05',
        '06',
        '07',
        '08',
        '09',
        '10',
        '11',
        '12',
      ];

  static List<String> get weekFullName => [
        '星期一',
        '星期二',
        '星期三',
        '星期四',
        '星期五',
        '星期六',
        '星期日',
      ];

  static List<String> get weekShortName => [
        '周一',
        '周二',
        '周三',
        '周四',
        '周五',
        '周六',
        '周日',
      ];

  static List<String> get weekMinName => [
        '日',
        '一',
        '二',
        '三',
        '四',
        '五',
        '六',
      ];
}
