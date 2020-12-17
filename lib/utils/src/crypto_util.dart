import 'dart:convert';
import 'dart:typed_data';

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
