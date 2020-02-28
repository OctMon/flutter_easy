import 'package:flutter_des/flutter_des.dart';
import 'package:flutter_easy/utils/global_util.dart';

import 'shared_preferences_util.dart';

String _secret;

class StorageUtil {
  static void setEncrypt(String secret) => _secret = secret;
}

Future<String> getStorageString(String key) async {
  String string = await SharedPreferencesUtil.getSharedPrefsString(key);
  return (isWeb || _secret == null || string == null)
      ? string
      : await FlutterDes.decryptFromBase64(string, _secret);
}

Future<bool> setStorageString(String key, String value) async {
  return SharedPreferencesUtil.setSharedPrefsString(
      key,
      (isWeb || _secret == null)
          ? value
          : await FlutterDes.encryptToBase64(value, _secret));
}

Future<bool> getStorageBool(String key) async {
  return await getStorageString(key) == "true";
}

Future<bool> setStorageBool(String key, bool value) {
  return setStorageString(key, value ? "true" : "false");
}

Future<bool> removeStorage(String key) {
  return SharedPreferencesUtil.removeSharedPrefs(key);
}

Future<bool> clearStorage() {
  return SharedPreferencesUtil.clearSharedPrefs();
}
