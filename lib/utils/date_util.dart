import '../utils/lunar/lunar_solar_converter.dart';

/// 获取当前时间戳
int get timestamp => timestampBy(DateTime.now());

/// 获取指定时间戳
int timestampBy(DateTime dateTime) => dateTime.millisecondsSinceEpoch ~/ 1000;

/// 时间戳转yyyy-MM-dd HH:mm:ss
// ignore: non_constant_identifier_names
String timestampToNormal_yyyy_MM_dd_HH_mm_ss(int timestamp,
    {bool isUtc = false}) {
  DateTime dateTime = timestampToDateTime(timestamp, isUtc: isUtc);
  return '${dateTime.year}-${_fixedZero2(dateTime.month)}-${_fixedZero2(dateTime.day)} ${_fixedZero2(dateTime.hour)}:${_fixedZero2(dateTime.minute)}:${_fixedZero2(dateTime.second)}';
}

/// 时间戳转yyyy年MM月dd日 HH时mm分ss秒
// ignore: non_constant_identifier_names
String timestampToZh_yyyy_MM_dd_HH_mm_ss(int timestamp, {bool isUtc = false}) {
  DateTime dateTime = timestampToDateTime(timestamp, isUtc: isUtc);
  return '${dateTime.year}年${_fixedZero2(dateTime.month)}月${_fixedZero2(dateTime.day)}日 ${_fixedZero2(dateTime.hour)}时${_fixedZero2(dateTime.minute)}分${_fixedZero2(dateTime.second)}秒';
}

/// 时间戳转yyyy年MM月dd日 HH时mm分
// ignore: non_constant_identifier_names
String timestampToZh_yyyy_MM_dd_HH_mm(int timestamp, {bool isUtc = false}) {
  DateTime dateTime = timestampToDateTime(timestamp, isUtc: isUtc);
  return '${dateTime.year}年${_fixedZero2(dateTime.month)}月${_fixedZero2(dateTime.day)}日 ${_fixedZero2(dateTime.hour)}时${_fixedZero2(dateTime.minute)}分';
}

/// 时间戳转HH:mm
// ignore: non_constant_identifier_names
String timestampTo_HH_mm(int timestamp,
    {String unit = ':', bool isUtc = false}) {
  DateTime dateTime = timestampToDateTime(timestamp, isUtc: isUtc);
  return '${_fixedZero2(dateTime.hour)}:${_fixedZero2(dateTime.minute)}';
}

/// 时间戳转yyyy年MM月dd日
// ignore: non_constant_identifier_names
String timestampToZh_yyyy_MM_dd(int timestamp, {bool isUtc = false}) {
  DateTime dateTime = timestampToDateTime(timestamp, isUtc: isUtc);
  return '${dateTime.year}年${_fixedZero2(dateTime.month)}月${_fixedZero2(dateTime.day)}日';
}

/// 时间戳转yyyy年MM月
// ignore: non_constant_identifier_names
String timestampToZh_yyyy_MM(int timestamp, {bool isUtc = false}) {
  DateTime dateTime = timestampToDateTime(timestamp, isUtc: isUtc);
  return '${dateTime.year}年${_fixedZero2(dateTime.month)}月';
}

/// 时间戳转DateTime
DateTime timestampToDateTime(int timestamp, {bool isUtc = false}) =>
    DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: isUtc);

/// 不足两位前面补0
String _fixedZero2(int digits) => '$digits'.padLeft(2, '0');

/// 公历转农历
Lunar lunarSolarConverter(DateTime date) {
  Solar solar =
      Solar(solarYear: date.year, solarMonth: date.month, solarDay: date.day);
  return LunarSolarConverter.solarToLunar(solar);
}
