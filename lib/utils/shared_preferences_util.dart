import 'package:flutter_easy/utils/global_util.dart';

import 'hw/hw_mp.dart';

class SharedPreferencesUtil {
  SharedPreferencesUtil._();

  static dynamic instance;

  /// 初始化首选项信息
  /// SharedPreferences.getInstance()
  /// isWeb SharedPreferencesPlugin()
  /// isWindows SharedPreferencesWindows.instance
  static Future<dynamic> init() async {
    instance = await sharedPreferencesInstance();
    return instance;
  }

  static Future<String> getSharedPrefsString(String key) async {
    return isWeb || isWindows
        ? await _all(key)
        : SharedPreferencesUtil.instance.getString(key);
  }

  static Future<List<String>> getSharedPrefsStringList(String key) async {
    return isWeb || isWindows
        ? await _all(key)
        : SharedPreferencesUtil.instance.getStringList(key);
  }

  static Future<bool> setSharedPrefsString(String key, String value) async {
    return isWeb || isWindows
        ? SharedPreferencesUtil.instance
            .setValue("String", _checkPrefix(key), value)
        : SharedPreferencesUtil.instance.setString(key, value);
  }

  static Future<bool> setSharedPrefsStringList(
      String key, List<String> value) async {
    return isWeb || isWindows
        ? SharedPreferencesUtil.instance
            .setValue("StringList", _checkPrefix(key), value)
        : SharedPreferencesUtil.instance.setStringList(key, value);
  }

  static Future<bool> getSharedPrefsBool(String key) async {
    return isWeb || isWindows
        ? await _all(key)
        : SharedPreferencesUtil.instance.getBool(key);
  }

  static Future<bool> setSharedPrefsBool(String key, bool value) async {
    return isWeb || isWindows
        ? SharedPreferencesUtil.instance
            .setValue("Bool", _checkPrefix(key), value)
        : SharedPreferencesUtil.instance.setBool(key, value);
  }

  static Future<bool> removeSharedPrefs(String key) =>
      SharedPreferencesUtil.instance
          .remove(isWeb || isWindows ? _checkPrefix(key) : key);

  static Future<bool> clearSharedPrefs() =>
      SharedPreferencesUtil.instance.clear();

  static String _checkPrefix(key) =>
      key.startsWith('flutter.') ? key : "flutter.$key";

  static Future<dynamic> _all(String key) async {
    Map<String, Object> all = await SharedPreferencesUtil.instance.getAll();
    return all != null ? all[_checkPrefix(key)] : {};
  }
}
