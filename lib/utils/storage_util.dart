import 'package:flutter_des/flutter_des.dart';

import 'shared_preferences_util.dart';

String _secret;

class StorageUtil {
  void setEncrypt(String secret) => _secret = secret;
}

Future<String> getStoreString(String key) async {
  String string = SharedPreferencesUtil.instance.getString(key);
  return _secret == null
      ? string
      : await FlutterDes.decryptFromBase64(string, _secret);
}

Future<bool> setStoreString(String key, String value) async {
  return SharedPreferencesUtil.instance.setString(
      key,
      _secret == null
          ? value
          : await FlutterDes.encryptToBase64(value, _secret));
}

Future<bool> getStoreBool(String key) async {
  return await getStoreString(key) == "true";
}

Future<bool> setStoreBool(String key, bool value) async {
  return setStoreString(key, value ? "true" : "false");
}

Future<bool> removeStore(String key) async {
  return SharedPreferencesUtil.instance.remove(key);
}

Future<bool> clearStore() async {
  return SharedPreferencesUtil.instance.clear();
}
