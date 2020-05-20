import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart' as convert;
import 'package:crypto/crypto.dart' as crypto;

/// md5加密
String md5(String data) {
  var content = utf8.encode(data);
  var digest = crypto.md5.convert(content);
  // 这里其实就是 digest.toString()
  return convert.hex.encode(digest.bytes);
}

/// base64加密字符串
String base64EncodeString(String data) => base64Encode(utf8.encode(data));

/// base64加密二进制
String base64Encode(List<int> input) => base64.encode(input);

/// base64解密字符串
String base64DecodeString(String data) {
  Uint8List decode = base64Decode(data);
  return decode != null ? utf8.decode(decode) : "";
}

/// base64解密字符串
Uint8List base64Decode(String encoded) {
  Uint8List decode;
  try {
    decode = base64.decode(encoded);
  } catch (e) {}
  return decode;
}
