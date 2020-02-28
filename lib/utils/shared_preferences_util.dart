import 'package:flutter_easy/utils/global_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart'; // TODO:运行web报错的时候注掉即可

class SharedPreferencesUtil {
  SharedPreferencesUtil._();

  /// SharedPreferences
  /// SharedPreferencesPlugin
  static dynamic instance;

  /// 初始化首选项信息
  static Future<SharedPreferences> init() async {
    if (isWeb) {
      instance = SharedPreferencesPlugin(); // TODO:运行web报错的时候注掉即可
    } else {
      instance = await SharedPreferences.getInstance();
    }
    return instance;
  }

  static Future<String> getSharedPrefsString(String key) async {
    return isWeb
        ? await _all(key)
        : SharedPreferencesUtil.instance.getString(key);
  }

  static Future<List<String>> getSharedPrefsStringList(String key) async {
    return isWeb
        ? await _all(key)
        : SharedPreferencesUtil.instance.getStringList(key);
  }

  static Future<bool> setSharedPrefsString(String key, String value) async {
    return isWeb
        ? SharedPreferencesUtil.instance
            .setValue("String", _checkPrefix(key), value)
        : SharedPreferencesUtil.instance.setString(key, value);
  }

  static Future<bool> setSharedPrefsStringList(
      String key, List<String> value) async {
    return isWeb
        ? SharedPreferencesUtil.instance
            .setValue("StringList", _checkPrefix(key), value)
        : SharedPreferencesUtil.instance.setStringList(key, value);
  }

  static Future<bool> getSharedPrefsBool(String key) async {
    return isWeb
        ? await _all(key)
        : SharedPreferencesUtil.instance.getBool(key);
  }

  static Future<bool> setSharedPrefsBool(String key, bool value) async {
    return isWeb
        ? SharedPreferencesUtil.instance
            .setValue("Bool", _checkPrefix(key), value)
        : SharedPreferencesUtil.instance.setBool(key, value);
  }

  static Future<bool> removeSharedPrefs(String key) =>
      SharedPreferencesUtil.instance.remove(isWeb ? _checkPrefix(key) : key);

  static Future<bool> clearSharedPrefs() =>
      SharedPreferencesUtil.instance.clear();

  static String _checkPrefix(key) =>
      key.startsWith('flutter.') ? key : "flutter.$key";

  static Future<dynamic> _all(String key) async {
    Map<String, Object> all = await SharedPreferencesUtil.instance.getAll();
    return all != null ? all[_checkPrefix(key)] : {};
  }
}
