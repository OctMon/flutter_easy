import 'dart:typed_data';

import '../vendor_util.dart';

dynamic sharedPreferencesInstance() => throw UnsupportedError("unsupported");

String get webUserAgent => throw UnsupportedError("unsupported");

String get webOrigin => throw UnsupportedError("unsupported");

/// 取缓存文件
Future<dynamic> hwCacheGetFile(String url,
        {String? cacheKey, String? cacheTag}) =>
    throw UnsupportedError("unsupported");

Future<Uint8List?> hwFetchBlobData(String url) =>
    throw UnsupportedError("unsupported");

void hwDownloadBlobData({required List blobParts, String? filename}) =>
    throw UnsupportedError("unsupported");

BaseExtendedImageProvider hwBaseExtendedFileImageProvider(String url,
        {double scale = 1.0,
        bool cacheRawData = false,
        String? imageCacheName}) =>
    throw UnsupportedError("unsupported");

String? hwGetQueryParam(String key) => throw UnsupportedError("unsupported");

Map<String, String> hwGetAllParams() => throw UnsupportedError("unsupported");

String? hwGetHash() => throw UnsupportedError("unsupported");

void hwSetLocationHref(String href) => throw UnsupportedError("unsupported");
