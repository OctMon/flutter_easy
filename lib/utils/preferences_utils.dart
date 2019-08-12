import 'package:mmkv_flutter/mmkv_flutter.dart';

Future<MmkvFlutter> mmkv = MmkvFlutter.getInstance();
getMmkvString(String key) async => (await mmkv).getString(key);
setMmkvString(String key, String value) async =>
    (await mmkv).setString(key, value);
removeMmkvByKey(String key) async => (await mmkv).removeByKey(key);
