/// 获取当前时间戳
int get timestamp => DateTime.now().millisecondsSinceEpoch ~/ 1000;

/// 时间戳转换为yyyy年MM月dd日
String timestampToYYYYMMdd(int timestamp, {bool isUtc = false}) {
  DateTime dateTime = timestampToDateTime(timestamp, isUtc: isUtc);
  return '${dateTime.year}年${dateTime.month.toString().length > 1 ? dateTime.month : '0${dateTime.month}'}月${dateTime.day.toString().length > 1 ? dateTime.day : '0${dateTime.day}'}日';
}

/// 时间戳转换为DateTime
DateTime timestampToDateTime(int timestamp, {bool isUtc = false}) =>
    DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: isUtc);
