import '../../utils/src/vendor_util.dart';

extension DateTimeExtension on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
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
