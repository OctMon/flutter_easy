part of lunar_calendar_converter;

class Lunar {
  /// 农历对应的公历年份。如 2018 表示与公历公元 2018 年对应的农历戊戌年；-200 表示与公历公元前 200 年对应的农历辛丑年；0/-1 年均表示公历公元前 1 年，农历庚申年。
  int _lunarYear;
  DateTime _dateTime;

  String get lunarYearString {
    String result = "";
    if (lunarYear != null) {
      int year = lunarYear;
      if (year < 0) {
        // 确保能读到正确的天干地支数据
        year++;
      }
      if (year < 1900) {
        // 把远古年代转到近代来计算天干地支
        year += ((2018 - year) / 60).floor() * 60;
      }
//      int absYear = lunarYear.abs();
//      String prefix = (lunarYear < 0 ? "公元前" : "") + "$absYear";
      result = ((_tianganList[(year - 4) % _tianganList.length]) +
          (_dizhiList[(year - 4) % _dizhiList.length]) +
          "年");
    }
    return result;
  }

  int lunarMonth;

  String get lunarMonthString {
    String result = "";
    if (lunarMonth != null) {
      if (lunarMonth < 1 || lunarMonth > 12) {
        result = "非法日期";
      }
      String month = _lunarMonthList[lunarMonth - 1];
      String leap = isLeap ? "闰" : "";
      result = "$leap$month月";
    }
    return result;
  }

  int lunarDay;

  String get lunarDayString {
    String result = "";
    if (lunarDay != null) {
      if (lunarDay < 1 || lunarDay > 30) {
        result = "非法日期";
      }
      result = _lunarDayList[lunarDay - 1];
    }
    return result;
  }

  static String _getDateString(int month, int day) {
    return (month >= 10 ? month.toString() : "0$month") +
        (day >= 10 ? day.toString() : "0$day");
  }

  /// 星期几
  String get weekString {
    return _weekList[_dateTime.weekday - 1];
  }

  /// 公历节日
  String get solarFestival {
    String text = _getDateString(_dateTime.month, _dateTime.day);
    String solar = "";
    for (String aMSolarCalendar in _solarFestivalList) {
      if (aMSolarCalendar.contains(text)) {
        solar = aMSolarCalendar.replaceAll(text, "");
        break;
      }
    }
    return solar;
  }

  /// 传统农历节日
  String get traditionLunarFestival {
    if (lunarMonth == 12) {
      int count =
          ((_lunarInfo[lunarYear - 1900] & (0x100000 >> lunarMonth)) == 0)
              ? 29
              : 30;
      if (lunarDay == count) {
        return _traditionLunarFestivalList.first; //除夕
      }
    }
    String text = _getDateString(lunarMonth, lunarDay);
    String festivalStr = "";
    for (String festival in _traditionLunarFestivalList) {
      if (festival.contains(text)) {
        festivalStr = festival.replaceAll(text, "");
        break;
      }
    }
    return festivalStr;
  }

  /// 生肖
  String get twelveSymbolicAnimalsYear {
    return _twelveSymbolicAnimalsList[(lunarYear - 1900) % 12];
  }

  bool isLeap;

  static List<String> _lunarMonthList = [
    '正',
    '二',
    '三',
    '四',
    '五',
    '六',
    '七',
    '八',
    '九',
    '十',
    '冬',
    '腊'
  ];
  static List<String> _lunarDayList = [
    '初一',
    '初二',
    '初三',
    '初四',
    '初五',
    '初六',
    '初七',
    '初八',
    '初九',
    '初十',
    '十一',
    '十二',
    '十三',
    '十四',
    '十五',
    '十六',
    '十七',
    '十八',
    '十九',
    '二十',
    '廿一',
    '廿二',
    '廿三',
    '廿四',
    '廿五',
    '廿六',
    '廿七',
    '廿八',
    '廿九',
    '三十'
  ];
  static List<String> _tianganList = [
    "甲",
    "乙",
    "丙",
    "丁",
    "戊",
    "己",
    "庚",
    "辛",
    "壬",
    "癸"
  ];
  static List<String> _dizhiList = [
    "子",
    "丑",
    "寅",
    "卯",
    "辰",
    "巳",
    "午",
    "未",
    "申",
    "酉",
    "戌",
    "亥"
  ];
  static List<String> _weekList = [
    "星期一",
    "星期二",
    "星期三",
    "星期四",
    "星期五",
    "星期六",
    "星期日",
  ];

  /// 用来表示1900年到2099年间农历年份的相关信息，共24位bit的16进制表示，其中：
  /// 1. 前4位表示该年闰哪个月；
  /// 2. 5-17位表示农历年份13个月的大小月分布，0表示小，1表示大；
  /// 3. 最后7位表示农历年首（正月初一）对应的公历日期。
  /// 以2014年的数据0x955ABF为例说明：
  /// 1001 0101 0101 1010 1011 1111
  /// 闰九月 农历正月初一对应公历1月31号
  static final List<int> _lunarInfo = [
    0x84B6BF,
    /*1900*/
    0x04AE53,
    0x0A5748,
    0x5526BD,
    0x0D2650,
    0x0D9544,
    0x46AAB9,
    0x056A4D,
    0x09AD42,
    0x24AEB6,
    0x04AE4A,
    /*1901-1910*/
    0x6A4DBE,
    0x0A4D52,
    0x0D2546,
    0x5D52BA,
    0x0B544E,
    0x0D6A43,
    0x296D37,
    0x095B4B,
    0x749BC1,
    0x049754,
    /*1911-1920*/
    0x0A4B48,
    0x5B25BC,
    0x06A550,
    0x06D445,
    0x4ADAB8,
    0x02B64D,
    0x095742,
    0x2497B7,
    0x04974A,
    0x664B3E,
    /*1921-1930*/
    0x0D4A51,
    0x0EA546,
    0x56D4BA,
    0x05AD4E,
    0x02B644,
    0x393738,
    0x092E4B,
    0x7C96BF,
    0x0C9553,
    0x0D4A48,
    /*1931-1940*/
    0x6DA53B,
    0x0B554F,
    0x056A45,
    0x4AADB9,
    0x025D4D,
    0x092D42,
    0x2C95B6,
    0x0A954A,
    0x7B4ABD,
    0x06CA51,
    /*1941-1950*/
    0x0B5546,
    0x555ABB,
    0x04DA4E,
    0x0A5B43,
    0x352BB8,
    0x052B4C,
    0x8A953F,
    0x0E9552,
    0x06AA48,
    0x6AD53C,
    /*1951-1960*/
    0x0AB54F,
    0x04B645,
    0x4A5739,
    0x0A574D,
    0x052642,
    0x3E9335,
    0x0D9549,
    0x75AABE,
    0x056A51,
    0x096D46,
    /*1961-1970*/
    0x54AEBB,
    0x04AD4F,
    0x0A4D43,
    0x4D26B7,
    0x0D254B,
    0x8D52BF,
    0x0B5452,
    0x0B6A47,
    0x696D3C,
    0x095B50,
    /*1971-1980*/
    0x049B45,
    0x4A4BB9,
    0x0A4B4D,
    0xAB25C2,
    0x06A554,
    0x06D449,
    0x6ADA3D,
    0x0AB651,
    0x095746,
    0x5497BB,
    /*1981-1990*/
    0x04974F,
    0x064B44,
    0x36A537,
    0x0EA54A,
    0x86B2BF,
    0x05AC53,
    0x0AB647,
    0x5936BC,
    0x092E50,
    0x0C9645,
    /*1991-2000*/
    0x4D4AB8,
    0x0D4A4C,
    0x0DA541,
    0x25AAB6,
    0x056A49,
    0x7AADBD,
    0x025D52,
    0x092D47,
    0x5C95BA,
    0x0A954E,
    /*2001-2010*/
    0x0B4A43,
    0x4B5537,
    0x0AD54A,
    0x955ABF,
    0x04BA53,
    0x0A5B48,
    0x652BBC,
    0x052B50,
    0x0A9345,
    0x474AB9,
    /*2011-2020*/
    0x06AA4C,
    0x0AD541,
    0x24DAB6,
    0x04B64A,
    0x6a573D,
    0x0A4E51,
    0x0D2646,
    0x5E933A,
    0x0D534D,
    0x05AA43,
    /*2021-2030*/
    0x36B537,
    0x096D4B,
    0xB4AEBF,
    0x04AD53,
    0x0A4D48,
    0x6D25BC,
    0x0D254F,
    0x0D5244,
    0x5DAA38,
    0x0B5A4C,
    /*2031-2040*/
    0x056D41,
    0x24ADB6,
    0x049B4A,
    0x7A4BBE,
    0x0A4B51,
    0x0AA546,
    0x5B52BA,
    0x06D24E,
    0x0ADA42,
    0x355B37,
    /*2041-2050*/
    0x09374B,
    0x8497C1,
    0x049753,
    0x064B48,
    0x66A53C,
    0x0EA54F,
    0x06AA44,
    0x4AB638,
    0x0AAE4C,
    0x092E42,
    /*2051-2060*/
    0x3C9735,
    0x0C9649,
    0x7D4ABD,
    0x0D4A51,
    0x0DA545,
    0x55AABA,
    0x056A4E,
    0x0A6D43,
    0x452EB7,
    0x052D4B,
    /*2061-2070*/
    0x8A95BF,
    0x0A9553,
    0x0B4A47,
    0x6B553B,
    0x0AD54F,
    0x055A45,
    0x4A5D38,
    0x0A5B4C,
    0x052B42,
    0x3A93B6,
    /*2071-2080*/
    0x069349,
    0x7729BD,
    0x06AA51,
    0x0AD546,
    0x54DABA,
    0x04B64E,
    0x0A5743,
    0x452738,
    0x0D264A,
    0x8E933E,
    /*2081-2090*/
    0x0D5252,
    0x0DAA47,
    0x66B53B,
    0x056D4F,
    0x04AE45,
    0x4A4EB9,
    0x0A4D4C,
    0x0D1541,
    0x2D92B5 /*2091-2099*/
  ];

  /// 公历节日
  static List<String> _solarFestivalList = [
    "0101元旦",
    "0214情人节",
    "0308妇女节",
    "0312植树节",
    "0315消权日",
    "0401愚人节",
    "0422地球日",
    "0501劳动节",
    "0504青年节",
    "0601儿童节",
    "0701建党节",
    "0801建军节",
    "0910教师节",
    "1001国庆节",
    "1031万圣节",
    "1111光棍节",
    "1224平安夜",
    "1225圣诞节",
  ];

  /// 传统农历节日
  static List<String> _traditionLunarFestivalList = [
    "除夕",
    "0101春节",
    "0115元宵",
    "0505端午",
    "0707七夕",
    "0815中秋",
    "0909重阳",
  ];

  /// 传统农历节日
  static List<String> _twelveSymbolicAnimalsList = [
    "鼠",
    "牛",
    "虎",
    "兔",
    "龙",
    "蛇",
    "马",
    "羊",
    "猴",
    "鸡",
    "狗",
    "猪",
  ];

  Lunar(DateTime dateTime,
      {int lunarYear, int lunarMonth, int lunarDay, bool isLeap}) {
    this._dateTime = dateTime;
    this.lunarYear = lunarYear;
    this.lunarMonth = lunarMonth;
    this.lunarDay = lunarDay;
    this.isLeap = isLeap == null ? false : isLeap;
  }

  set lunarYear(int v) {
    if (v == 0) {
      //规定公元 0 年即公元前 1 年
      v = -1;
    }
    _lunarYear = v;
  }

  int get lunarYear => _lunarYear;

  toString() {
    String result = lunarYearString + lunarMonthString + lunarDayString;
    return result.isEmpty ? "非法日期" : result;
  }
}
