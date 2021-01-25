import 'package:flutter_easy/flutter_easy.dart';

import 'lunar/lunar_solar_converter.dart';

/// 获取当前时间戳
int timestampNow() => timestampBy(DateTime.now());

/// 获取指定时间戳
int timestampBy(DateTime dateTime) => dateTime.millisecondsSinceEpoch ~/ 1000;

/// 时间戳转yyyy-MM-dd HH:mm:ss
// ignore: non_constant_identifier_names
String timestampToNormal_yyyy_MM_dd_HH_mm_ss(int timestamp,
    {bool isUtc = false}) {
  DateTime dateTime = timestampToDateTime(timestamp, isUtc: isUtc);
  return '${dateTime.year}-${twoDigits(dateTime.month)}-${twoDigits(dateTime.day)} ${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}:${twoDigits(dateTime.second)}';
}

/// 时间戳转yyyy-MM-dd
// ignore: non_constant_identifier_names
String timestampToNormal_yyyy_MM_dd(int timestamp, {bool isUtc = false}) {
  DateTime dateTime = timestampToDateTime(timestamp, isUtc: isUtc);
  return '${dateTime.year}-${twoDigits(dateTime.month)}-${twoDigits(dateTime.day)}';
}

/// 时间戳转yyyy年MM月dd日 HH时mm分ss秒
// ignore: non_constant_identifier_names
String timestampToZh_yyyy_MM_dd_HH_mm_ss(int timestamp, {bool isUtc = false}) {
  DateTime dateTime = timestampToDateTime(timestamp, isUtc: isUtc);
  return '${dateTime.year}年${twoDigits(dateTime.month)}月${twoDigits(dateTime.day)}日 ${twoDigits(dateTime.hour)}时${twoDigits(dateTime.minute)}分${twoDigits(dateTime.second)}秒';
}

/// 时间戳转yyyy年MM月dd日 HH时mm分
// ignore: non_constant_identifier_names
String timestampToZh_yyyy_MM_dd_HH_mm(int timestamp, {bool isUtc = false}) {
  DateTime dateTime = timestampToDateTime(timestamp, isUtc: isUtc);
  return '${dateTime.year}年${twoDigits(dateTime.month)}月${twoDigits(dateTime.day)}日 ${twoDigits(dateTime.hour)}时${twoDigits(dateTime.minute)}分';
}

/// 时间戳转HH:mm
// ignore: non_constant_identifier_names
String timestampTo_HH_mm(int timestamp,
    {String unit = ':', bool isUtc = false}) {
  DateTime dateTime = timestampToDateTime(timestamp, isUtc: isUtc);
  return '${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}';
}

/// 时间戳转yyyy年MM月dd日
// ignore: non_constant_identifier_names
String timestampToZh_yyyy_MM_dd(int timestamp, {bool isUtc = false}) {
  DateTime dateTime = timestampToDateTime(timestamp, isUtc: isUtc);
  return '${dateTime.year}年${twoDigits(dateTime.month)}月${twoDigits(dateTime.day)}日';
}

/// 时间戳转yyyy年MM月
// ignore: non_constant_identifier_names
String timestampToZh_yyyy_MM(int timestamp, {bool isUtc = false}) {
  DateTime dateTime = timestampToDateTime(timestamp, isUtc: isUtc);
  return '${dateTime.year}年${twoDigits(dateTime.month)}月';
}

/// 时间戳转DateTime
DateTime timestampToDateTime(int timestamp, {bool isUtc = false}) =>
    DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: isUtc);

/// 不足两位前面补0
String twoDigits(int n) {
  if (n >= 10) return "$n";
  return "0$n";
}

/// 公历转农历
Lunar lunarSolarConverter(DateTime date) {
  Solar solar =
      Solar(solarYear: date.year, solarMonth: date.month, solarDay: date.day);
  return LunarSolarConverter.solarToLunar(solar);
}

/// 标志	星座	拉丁名称	出生日期（公历）	别名
/// ♈
/// 白羊座
/// Aries
/// 3月21日~4月19日
/// 牡羊座
/// ♉
/// 金牛座
/// Taurus
/// 4月20日～5月20日
/// 金牛座
/// ♊
/// 双子座
/// Gemini
/// 5月21日～6月21日
/// 双子座
/// ♋
/// 巨蟹座
/// Cancer
/// 6月22日～7月22日
/// 巨蟹座
/// ♌
/// 狮子座
/// Leo
/// 7月23日～8月22日
/// 狮子座
/// ♍
/// 处女座
/// Virgo
/// 8月23日～9月22日
/// 室女座
/// ♎
/// 天秤座
/// Libra
/// 9月23日～10月23日
/// 天平座
/// ♏
/// 天蝎座
/// Scorpio
/// 10月24日～11月22日
/// 天蝎座
/// ♐
/// 射手座
/// Sagittarius
/// 11月23日～12月21日
/// 人马座
/// ♑
/// 摩羯座
/// Capricorn
/// 12月22日～1月19日
/// 山羊座
/// ♒
/// 水瓶座
/// Aquarius
/// 1月20日～2月18日
/// 宝瓶座
/// ♓
/// 双鱼座
/// Pisces
/// 2月19日～3月20日
/// 双鱼座
/// "${(constellation.extend as List<String>).first.split("-").map((e) => e.padLeft(2, "0")).join("月")}日 - ${(constellation.extend as List<String>).last.split("-").map((e) => e.padLeft(2, "0")).join("月")}日"
BaseKeyValue twelveConstellationBy(DateTime dateTime) {
  if (dateTime.month == 3 && dateTime.day >= 21 ||
      dateTime.month == 4 && dateTime.day <= 19) {
    return BaseKeyValue(key: "aries", value: "白羊座", extend: ["3-21", "4-19"]);
  } else if (dateTime.month == 4 && dateTime.day >= 20 ||
      dateTime.month == 5 && dateTime.day <= 20) {
    return BaseKeyValue(key: "taurus", value: "金牛座", extend: ["4-20", "5-20"]);
  } else if (dateTime.month == 5 && dateTime.day >= 21 ||
      dateTime.month == 6 && dateTime.day <= 21) {
    return BaseKeyValue(key: "gemini", value: "双子座", extend: ["5-21", "6-21"]);
  } else if (dateTime.month == 6 && dateTime.day >= 22 ||
      dateTime.month == 7 && dateTime.day <= 22) {
    return BaseKeyValue(key: "cancer", value: "巨蟹座", extend: ["6-22", "7-22"]);
  } else if (dateTime.month == 7 && dateTime.day >= 23 ||
      dateTime.month == 8 && dateTime.day <= 22) {
    return BaseKeyValue(key: "leo", value: "狮子座", extend: ["7-23", "8-22"]);
  } else if (dateTime.month == 8 && dateTime.day >= 23 ||
      dateTime.month == 9 && dateTime.day <= 22) {
    return BaseKeyValue(key: "virgo", value: "处女座", extend: ["8-23", "9-22"]);
  } else if (dateTime.month == 9 && dateTime.day >= 23 ||
      dateTime.month == 10 && dateTime.day <= 23) {
    return BaseKeyValue(key: "libra", value: "天秤座", extend: ["9-23", "10-23"]);
  } else if (dateTime.month == 10 && dateTime.day >= 24 ||
      dateTime.month == 11 && dateTime.day <= 22) {
    return BaseKeyValue(
        key: "scorpio", value: "天蝎座", extend: ["10-24", "11-22"]);
  } else if (dateTime.month == 11 && dateTime.day >= 23 ||
      dateTime.month == 12 && dateTime.day <= 21) {
    return BaseKeyValue(
        key: "sagittarius", value: "射手座", extend: ["11-23", "12-21"]);
  } else if (dateTime.month == 12 && dateTime.day >= 22 ||
      dateTime.month == 1 && dateTime.day <= 19) {
    return BaseKeyValue(
        key: "capricorn", value: "摩羯座", extend: ["12-22", "1-19"]);
  } else if (dateTime.month == 1 && dateTime.day >= 20 ||
      dateTime.month == 2 && dateTime.day <= 18) {
    return BaseKeyValue(
        key: "aquarius", value: "水瓶座", extend: ["1-20", "2-18"]);
  } else {
    return BaseKeyValue(key: "pisces", value: "双鱼座", extend: ["2-19", "3-20"]);
  }
}

BaseKeyValue twelveConstellationNow() {
  return twelveConstellationBy(DateTime.now());
}
