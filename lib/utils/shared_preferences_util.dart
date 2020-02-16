import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  SharedPreferencesUtil._();

  static SharedPreferences instance;

  /// 初始化首选项信息
  static Future<SharedPreferences> init() async {
    instance = await SharedPreferences.getInstance();
    return instance;
  }
}

String getSharedPrefsString(String key) =>
    SharedPreferencesUtil.instance.getString(key);

Future<bool> setSharedPrefsString(String key, String value) async =>
    SharedPreferencesUtil.instance.setString(key, value);

bool getSharedPrefsBool(String key) =>
    SharedPreferencesUtil.instance.getBool(key);

Future<bool> setSharedPrefsBool(String key, bool value) async =>
    SharedPreferencesUtil.instance.setBool(key, value);

Future<bool> removeSharedPrefs(String key) async =>
    SharedPreferencesUtil.instance.remove(key);
