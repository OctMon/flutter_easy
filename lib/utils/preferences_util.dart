import 'package:mmkv_flutter/mmkv_flutter.dart';

Future<MmkvFlutter> mmkv = MmkvFlutter.getInstance();
Future<String> getMmkvString(String key) async => (await mmkv).getString(key);
Future<bool> setMmkvString(String key, String value) async =>
    (await mmkv).setString(key, value);
Future<bool> removeMmkvByKey(String key) async => (await mmkv).removeByKey(key);
