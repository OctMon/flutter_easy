import 'dart:io';
import 'package:encrypt/encrypt.dart';

import 'package:path_provider/path_provider.dart';

import 'json_util.dart';
import 'logger_util.dart';
import 'shared_preferences_util.dart';

String? _secret;

class StorageUtil {
  static void setEncrypt(String secret) => _secret = secret;
}

final _encrypt = Encrypter(AES(Key.fromUtf8(_secret ?? ""), mode: AESMode.ecb));
final _iv = IV.fromLength(16);

Future<String?> getStorageString(String key) async {
  String? string = await SharedPreferencesUtil.getSharedPrefsString(key);
  if (_secret == null || string == null) {
    return string;
  }
//  if (isWeb) {
  return _encrypt.decrypt(Encrypted.fromBase64(string), iv: _iv);
//  }
//  return await FlutterDes.decryptFromBase64(string, _secret);
}

Future<bool> setStorageString(String key, String value) async {
  String string = value;
  string = _encrypt.encrypt(value, iv: _iv).base64;
  return SharedPreferencesUtil.setSharedPrefsString(key, string);
}

Future<bool> getStorageBool(String key) async {
  return await getStorageString(key) == "true";
}

Future<bool> setStorageBool(String key, bool value) {
  return setStorageString(key, value ? "true" : "false");
}

Future<Map<String, dynamic>?> getStorageMap(String key) async {
  final storage = await getStorageString(key);
  if (storage != null && storage.isNotEmpty) {
    return jsonDecode(storage);
  }
  return null;
}

Future<bool> setStorageMap(String key, Map<String, dynamic> value) async {
  return await setStorageString(key, jsonEncode(value));
}

/// var models = await getStorageList(_orderNoKey, listKey: _orderNoForUserKey,
///     onModels: (json) {
///   return BaseKeyValue.fromJson(json);
/// });
Future<List> getStorageList(String key,
    {required String listKey,
    required Function(Map<String, dynamic> json) onModels}) async {
  final map = await getStorageMap(key);
  var models = [];
  if (map != null) {
    final list = map[listKey];
    try {
      if (list.length > 0) {
        models = list.map((v) => onModels(v)).toList();
      }
    } catch (e) {
      logDebug(e);
    }
  }
  return models;
}

/// var models = await getStorageList(_orderNoKey, listKey: _orderNoForUserKey,
///     onModels: (json) {
///   return BaseKeyValue.fromJson(json);
/// });
/// models.add(BaseKeyValue(key: "key", value: "${randomInt(100)}"));
/// await setStorageList(_orderNoKey, listKey: _orderNoForUserKey, list: models);
Future<bool> setStorageList(String key,
    {required String listKey, required List list}) async {
  return await setStorageMap(key, {listKey: list});
}

Future<bool> removeStorage(String key) {
  return SharedPreferencesUtil.removeSharedPrefs(key);
}

Future<bool> clearStorage() {
  return SharedPreferencesUtil.clearSharedPrefs();
}

Future<String> calcTemporaryDirectoryCacheSize() async {
  Future<double> getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    try {
      if (file is File) {
        int length = await file.length();
        return double.parse(length.toString());
      }
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        double total = 0;
        for (final FileSystemEntity child in children)
          total += await getTotalSizeOfFilesInDir(child);
        return total;
      }
      return 0;
    } catch (err) {
      logError(err);
      return 0;
    }
  }

  convertSize(double value) {
    List<String> unitArr = []
      ..add('B')
      ..add('K')
      ..add('M')
      ..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }

  try {
    Directory tempDir = await getTemporaryDirectory();
    double value = await getTotalSizeOfFilesInDir(tempDir);
    return convertSize(value);
  } catch (err) {
    logError(err);
  }
  return "";
}

Future<bool> clearTemporaryDirectoryCache() async {
  Future<bool> delDir(FileSystemEntity file) async {
    try {
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        for (final FileSystemEntity child in children) {
          await delDir(child);
        }
      }
      await file.delete();
      return true;
    } catch (err) {
      logError(err);
      return false;
    }
  }

  try {
    Directory tempDir = await getTemporaryDirectory();
    // 删除缓存目录
    await delDir(tempDir).then((bool) {
      return true;
    });
    return false;
  } catch (err) {
    logError(err);
    return false;
  }
}
