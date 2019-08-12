import 'dart:convert';
import 'package:convert/convert.dart' as convert;
import 'package:crypto/crypto.dart' as crypto;

/// md5加密
String md5(String data) {
  var content = utf8.encode(data);
  var digest = crypto.md5.convert(content);
  // 这里其实就是 digest.toString()
  return convert.hex.encode(digest.bytes);
}