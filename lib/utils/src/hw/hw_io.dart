import 'package:extended_image/extended_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';

import 'package:flutter_easy/flutter_easy.dart';

String get webUserAgent => "";

String get webOrigin => "";

dynamic sharedPreferencesInstance() {
  if (isWindows) {
    return SharedPreferencesStorePlatform.instance;
  } else {
    return SharedPreferences.getInstance();
  }
}

/// 取缓存文件
Future<dynamic> hwCacheGetFile(String url, {String? cacheKey, String? cacheTag}) {
  return getCachedImageFile(url,
      cacheKey: BaseWebImage.keyToTagMd5(url, cacheKey, cacheTag));
}
