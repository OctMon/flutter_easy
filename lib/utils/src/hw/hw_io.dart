import 'dart:io';
import 'dart:typed_data';

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
Future<dynamic> hwCacheGetFile(String url,
    {String? cacheKey, String? cacheTag}) {
  return getCachedImageFile(url,
      cacheKey: BaseWebImage.keyToTagMd5(url, cacheKey, cacheTag));
}

Future<Uint8List?> hwFetchBlobData(String url) async {
  return null;
}

void hwDownloadBlobData({required List blobParts, String? filename}) {}

BaseExtendedImageProvider hwBaseExtendedFileImageProvider(String url,
    {double scale = 1.0, bool cacheRawData = false, String? imageCacheName}) {
  return BaseExtendedFileImageProvider(
    scale: scale,
    File(url),
    cacheRawData: cacheRawData,
    imageCacheName: imageCacheName,
  );
}

String? hwGetQueryParam(String key) => null;

Map<String, String> hwGetAllParams() => {};

String? hwGetHash() => null;

void hwSetLocationHref(String href) {}
