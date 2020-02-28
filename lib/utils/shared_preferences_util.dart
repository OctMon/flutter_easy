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

@Deprecated("use getStorageString")
String getSharedPrefsString(String key) =>
    SharedPreferencesUtil.instance.getString(key);

List<String> getSharedPrefsStringList(String key) =>
    SharedPreferencesUtil.instance.getStringList(key);

@Deprecated("use setStorageString")
Future<bool> setSharedPrefsString(String key, String value) async =>
    SharedPreferencesUtil.instance.setString(key, value);

Future<bool> setSharedPrefsStringList(String key, List<String> value) async =>
    SharedPreferencesUtil.instance.setStringList(key, value);

@Deprecated("use getStorageBool")
bool getSharedPrefsBool(String key) =>
    SharedPreferencesUtil.instance.getBool(key);

@Deprecated("use setStorageBool")
Future<bool> setSharedPrefsBool(String key, bool value) async =>
    SharedPreferencesUtil.instance.setBool(key, value);

@Deprecated("use removeStorage")
Future<bool> removeSharedPrefs(String key) async =>
    SharedPreferencesUtil.instance.remove(key);