import 'dart:io';
import 'package:encrypt/encrypt.dart';

//import 'package:flutter_des/flutter_des.dart';
import 'package:path_provider/path_provider.dart';

//import 'global_util.dart';
import 'logger_util.dart';
import 'shared_preferences_util.dart';

String _secret;

class StorageUtil {
  static void setEncrypt(String secret) => _secret = secret;
}

final _encrypt = Encrypter(AES(Key.fromUtf8(_secret), mode: AESMode.ecb));
final _iv = IV.fromLength(16);

Future<String> getStorageString(String key) async {
  String string = await SharedPreferencesUtil.getSharedPrefsString(key);
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
  if (string != null) {
//    if (isWeb) {
    string = _encrypt.encrypt(value, iv: _iv).base64;
//    } else {
//      string = await FlutterDes.encryptToBase64(value, _secret);
//    }
  }
  return SharedPreferencesUtil.setSharedPrefsString(key, string);
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
        if (children != null)
          for (final FileSystemEntity child in children)
            total += await getTotalSizeOfFilesInDir(child);
        return total;
      }
      return 0;
    } catch (err) {
      logger.e(err);
      return 0;
    }
  }

  convertSize(double value) {
    if (null == value) {
      return 0;
    }
    List<String> unitArr = List()..add('B')..add('K')..add('M')..add('G');
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
    logger.e(err);
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
      logger.e(err);
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
    logger.e(err);
    return false;
  }
}
