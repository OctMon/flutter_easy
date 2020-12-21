import 'dart:convert';

import 'package:convert/convert.dart' as convert;
import 'package:crypto/crypto.dart' as crypto;

import 'package:flutter_easy/flutter_easy.dart';

extension StringExtensions on String {
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

  /// 验证手机号码
  bool get isPhoneNumber =>
      hasMatch("^(1[3-9][0-9])\\d{8}\$") && this.length == 11;

  /// 验证邮箱
  bool get isEmail => hasMatch(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  /// RegExp Match pattern
  bool hasMatch(String pattern) {
    return (this == null) ? false : RegExp(pattern).hasMatch(this);
  }
}
