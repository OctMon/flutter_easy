import 'dart:typed_data';

import '../vendor_util.dart';

dynamic sharedPreferencesInstance() =>
    throw UnsupportedError("shared preferences instance error");

String get webUserAgent => throw UnsupportedError("get web user agent error");

String get webOrigin => throw UnsupportedError("get web origin error");

/// 取缓存文件
Future<dynamic> hwCacheGetFile(String url,
    {String? cacheKey, String? cacheTag}) {
  return Future.value(null);
}

Future<Uint8List?> hwFetchBlobData(String url) async {
  return null;
}

void hwDownloadBlobData({required List blobParts, String? filename}) {
  throw UnsupportedError("download blob data error");
}

BaseExtendedImageProvider hwBaseExtendedFileImageProvider(String url,
    {double scale = 1.0, bool cacheRawData = false, String? imageCacheName}) {
  throw UnsupportedError("provider error");
}
