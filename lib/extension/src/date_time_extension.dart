import '../../utils/src/vendor_util.dart';

extension DateTimeExtension on DateTime {
  /// 检查是否已经过期
  bool isOverdue({DateTime? today}) {
    final dateTime = today ?? DateTime.now();
    return isBefore(dateTime) && !isToday(today: dateTime);
  }

  /// 检查是否为今天
  bool isToday({DateTime? today}) {
    final now = today ?? DateTime.now();
    return isSameDay(now);
  }

  /// 检查是否为明天
  bool isTomorrow({DateTime? today}) {
    DateTime tomorrow = (today ?? DateTime.now()).add(Duration(days: 1));
    return isSameDay(tomorrow);
  }

  /// 检查是否为后天
  bool isDayAfterTomorrow({DateTime? today}) {
    DateTime dayAfterTomorrow =
        (today ?? DateTime.now()).add(Duration(days: 2));
    return isSameDay(dayAfterTomorrow);
  }

  /// 检查是否为同一天
  bool isSameDay(DateTime compareDate) {
    return year == compareDate.year &&
        month == compareDate.month &&
        day == compareDate.day;
  }

  bool isSameMonth({DateTime? compareDate}) {
    final dateTime = compareDate ?? DateTime.now();
    return year == dateTime.year && month == dateTime.month;
  }

  String toChatTimeFormat() {
    final now = DateTime.now();
    final difference = now.difference(this);
    final todayStart = DateTime(now.year, now.month, now.day); // 今天的零点
    final yesterdayStart = todayStart.subtract(Duration(days: 1)); // 昨天的零点

    if (isAfter(todayStart)) {
      // 今天
      return BaseDateFormat('HH:mm').format(this); // 仅显示时间
    } else if (isAfter(yesterdayStart)) {
      // 昨天
      return '昨天 ${BaseDateFormat('HH:mm').format(this)}';
    } else if (difference.inDays < 7) {
      // 本周内，显示星期几
      final weekDays = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'];
      return '${weekDays[this.weekday % 7]} ${BaseDateFormat('HH:mm').format(this)}';
    } else if (difference.inDays < 365) {
      // 一年内，显示“月-日”
      return BaseDateFormat('MM-dd HH:mm').format(this);
    } else {
      // 一周前，显示完整日期
      return BaseDateFormat('yyyy-MM-dd HH:mm').format(this);
    }
  }
}
