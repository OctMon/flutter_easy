import '../components/base.dart';
import '../utils/lunar/lunar_solar_converter.dart';

/// 获取当前时间戳
int timestampNow() => timestampBy(DateTime.now());

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
BaseKeyValue twelveConstellationBy(DateTime dateTime) {
  if (dateTime.month == 3 && dateTime.day >= 21 ||
      dateTime.month == 4 && dateTime.day <= 19) {
    return BaseKeyValue(key: "Aries", value: "白羊座");
  } else if (dateTime.month == 4 && dateTime.day >= 20 ||
      dateTime.month == 5 && dateTime.day <= 20) {
    return BaseKeyValue(key: "Taurus", value: "金牛座");
  } else if (dateTime.month == 5 && dateTime.day >= 21 ||
      dateTime.month == 6 && dateTime.day <= 21) {
    return BaseKeyValue(key: "Gemini", value: "双子座");
  } else if (dateTime.month == 6 && dateTime.day >= 22 ||
      dateTime.month == 7 && dateTime.day <= 22) {
    return BaseKeyValue(key: "Cancer", value: "巨蟹座");
  } else if (dateTime.month == 7 && dateTime.day >= 23 ||
      dateTime.month == 8 && dateTime.day <= 22) {
    return BaseKeyValue(key: "Leo", value: "狮子座");
  } else if (dateTime.month == 8 && dateTime.day >= 23 ||
      dateTime.month == 9 && dateTime.day <= 22) {
    return BaseKeyValue(key: "Virgo", value: "处女座");
  } else if (dateTime.month == 9 && dateTime.day >= 23 ||
      dateTime.month == 10 && dateTime.day <= 23) {
    return BaseKeyValue(key: "Libra", value: "天秤座");
  } else if (dateTime.month == 10 && dateTime.day >= 24 ||
      dateTime.month == 11 && dateTime.day <= 22) {
    return BaseKeyValue(key: "Scorpio", value: "天蝎座");
  } else if (dateTime.month == 11 && dateTime.day >= 23 ||
      dateTime.month == 12 && dateTime.day <= 21) {
    return BaseKeyValue(key: "Sagittarius", value: "射手座");
  } else if (dateTime.month == 12 && dateTime.day >= 22 ||
      dateTime.month == 1 && dateTime.day <= 19) {
    return BaseKeyValue(key: "Capricorn", value: "摩羯座");
  } else if (dateTime.month == 1 && dateTime.day >= 20 ||
      dateTime.month == 2 && dateTime.day <= 18) {
    return BaseKeyValue(key: "Aquarius", value: "水瓶座");
  } else {
    return BaseKeyValue(key: "Pisces", value: "双鱼座");
  }
}

BaseKeyValue twelveConstellationNow() {
  return twelveConstellationBy(DateTime.now());
}
