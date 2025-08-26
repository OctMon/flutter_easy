import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart' as convert;
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/widgets.dart';

import 'package:flutter_easy/flutter_easy.dart';

extension StringExtensions on String {
  String get escapedString {
    return runes.map((int rune) {
      if (rune > 127) {
        return '\\u${rune.toRadixString(16).padLeft(4, '0').toUpperCase()}';
      } else {
        return String.fromCharCode(rune);
      }
    }).join();
  }

  /// MD5
  String get md5 {
    if (this.isEmptyOrNull) {
      return "";
    }
    var content = utf8.encode(this);
    var digest = crypto.md5.convert(content);
    // 这里其实就是 digest.toString()
    return convert.hex.encode(digest.bytes);
  }

  /// HMAC-SHA256
  String hmacSha256({required String key}) {
    if (this.isEmptyOrNull) {
      return "";
    }
    var hmacSha256 = crypto.Hmac(crypto.sha256, utf8.encode(key));
    var digest = hmacSha256.convert(utf8.encode(this));

    return digest.toString();
  }

  /// HMAC-SHA256
  String get hmacSha256ToBase64 {
    if (this.isEmptyOrNull) {
      return "";
    }
    return base64Encode(crypto.Hmac(crypto.sha256, utf8.encode(this))
        .convert(Uint8List(0))
        .bytes);
  }

  /// 验证国内手机号码
  bool get isCNPhoneNumber =>
      hasMatch("^(1[3-9][0-9])\\d{8}\$") && this.length == 11;

  /// 验证邮箱
  bool get isEmail => hasMatch(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  /// RegExp Match pattern
  bool hasMatch(String pattern) {
    return RegExp(pattern).hasMatch(this);
  }

  /// 是否是弱密码
  bool get isWeakPassword {
    if (isNotEmpty != true) {
      // 密码为空，弱密码
      return true;
    }
    if (length < 8) {
      // 位数不足，弱密码
      return true;
    }
    Set set = HashSet();
    for (var code in codeUnits) {
      if (code >= 48 && code <= 57) {
        set.add('数字');
      } else if (code >= 65 && code <= 90) {
        set.add('大写');
      } else if (code >= 97 && code <= 122) {
        set.add('小写');
      } else {
        set.add('特殊');
      }
    }
    // 小于3种，弱密码
    return set.length < 3;
  }
}

extension IdentityCardExtensions on String {
  /// 校验身份证合法性
  bool get isIdentityCard {
    const Map city = {
      11: "北京",
      12: "天津",
      13: "河北",
      14: "山西",
      15: "内蒙古",
      21: "辽宁",
      22: "吉林",
      23: "黑龙江 ",
      31: "上海",
      32: "江苏",
      33: "浙江",
      34: "安徽",
      35: "福建",
      36: "江西",
      37: "山东",
      41: "河南",
      42: "湖北 ",
      43: "湖南",
      44: "广东",
      45: "广西",
      46: "海南",
      50: "重庆",
      51: "四川",
      52: "贵州",
      53: "云南",
      54: "西藏 ",
      61: "陕西",
      62: "甘肃",
      63: "青海",
      64: "宁夏",
      65: "新疆",
      71: "台湾",
      81: "香港",
      82: "澳门",
      91: "国外 "
    };
    if (!this.hasMatch(
        r'^\d{6}(18|19|20)?\d{2}(0[1-9]|1[012])(0[1-9]|[12]\d|3[01])\d{3}(\d|X)$')) {
      logDebug('身份证号格式错误');
      return false;
    }
    if (city[int.parse(this.substring(0, 2))] == null) {
      logDebug('地址编码错误');
      return false;
    }
    // 18位身份证需要验证最后一位校验位，15位不检测了，现在也没15位的了
    if (this.length == 18) {
      List numList = this.split('');
      // ∑(ai×Wi)(mod 11)
      // 加权因子
      List factor = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
      // 校验位
      List parity = [1, 0, 'X', 9, 8, 7, 6, 5, 4, 3, 2];
      int sum = 0;
      int ai = 0;
      int wi = 0;
      for (var i = 0; i < 17; i++) {
        ai = int.parse(numList[i]);
        wi = factor[i];
        sum += ai * wi;
      }
      if ("${parity[sum % 11]}" != numList[17]) {
        logDebug('校验位错误');
        return false;
      }
    } else {
      logDebug('身份证号不是18位');
      return false;
    }
    return true;
  }

  /// 根据身份证号获取年龄
  int get getAgeFromIdentityCard {
    if (!this.isIdentityCard) {
      return -1;
    }
    int len = this.length;
    String strBirthday = "";
    if (len == 18) {
      // 处理18位的身份证号码从号码中得到生日和性别代码
      strBirthday = this.substring(6, 10) +
          "-" +
          this.substring(10, 12) +
          "-" +
          this.substring(12, 14);
    }
    if (len == 15) {
      strBirthday = "19" +
          this.substring(6, 8) +
          "-" +
          this.substring(8, 10) +
          "-" +
          this.substring(10, 12);
    }
    int age = _getAgeFromBirthday(strBirthday);
    return age;
  }

  /// 根据出生日期获取年龄
  int _getAgeFromBirthday(String strBirthday) {
    if (strBirthday.isEmpty) {
      logDebug('生日错误');
      return 0;
    }
    DateTime birth = DateTime.parse(strBirthday);
    DateTime now = DateTime.now();

    int age = now.year - birth.year;
    // 再考虑月、天的因素
    if (now.month < birth.month ||
        (now.month == birth.month && now.day < birth.day)) {
      age--;
    }
    return age;
  }

  /// 根据身份证获取性别
  String get getSexFromIdentityCard {
    String sex = "";
    if (!this.isIdentityCard) {
      return sex;
    }
    if (this.length == 18) {
      if (int.parse(this.substring(16, 17)) % 2 == 1) {
        sex = "男";
      } else {
        sex = "女";
      }
    } else if (this.length == 15) {
      if (int.parse(this.substring(14, 15)) % 2 == 1) {
        sex = "男";
      } else {
        sex = "女";
      }
    }
    return sex;
  }
}

extension StringTextHeightExtension on String {
  double calculateTextHeight(
      {required TextStyle style,
      required double maxWidth,
      int maxLines = 1,
      TextAlign textAlign = TextAlign.start}) {
    final TextPainter textPainter = TextPainter(
      locale: appLocale,
      text: TextSpan(text: this, style: style),
      textDirection: TextDirection.ltr,
      maxLines: maxLines,
      textAlign: textAlign,
    )..layout(maxWidth: maxWidth);
    return textPainter.size.height;
  }

  /// 超过多少行文本是否溢出
  bool didExceedMaxLines({
    required TextStyle style,
    int maxLines = 1,
    required double maxWidth,
  }) {
    final tp = TextPainter(
      text: TextSpan(text: this, style: style),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    );

    tp.layout(maxWidth: maxWidth);

    return tp.didExceedMaxLines;
  }
}

extension FixAutoLinesExtensions on String {
  String get fixAutoLines {
    return Characters(this).join('\u200B');
  }
}

extension ColorExtensions on String {
  Color hexToColor() {
    String hex = replaceAll('#', '');
    if (hex.isEmpty) {
      throw ArgumentError('Invalid color: $this');
    }
    // 处理3位或4位缩写格式
    if (hex.length == 3 || hex.length == 4) {
      hex = hex.split('').map((c) => c + c).join();
    }
    // 补全透明度为不透明（FF）
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    // 验证长度是否为8位（ARGB）
    if (hex.length != 8) {
      throw ArgumentError('Invalid color length: $this');
    }
    // 转换为整数
    int? colorValue = int.tryParse(hex, radix: 16);
    if (colorValue == null) {
      throw ArgumentError('Invalid hex color: $this');
    }
    return Color(colorValue);
  }
}
