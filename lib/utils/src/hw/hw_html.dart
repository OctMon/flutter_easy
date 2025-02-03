// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:typed_data';

import 'package:extended_image_library/src/extended_file_image_provider.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import '../vendor_util.dart';

String get webUserAgent => window.navigator.userAgent;

String get webOrigin => window.origin ?? "";

dynamic sharedPreferencesInstance() => SharedPreferencesPlugin();

/// 取缓存文件
Future<dynamic> hwCacheGetFile(String url,
    {String? cacheKey, String? cacheTag}) {
  return Future.value(null);
}

Future<Uint8List?> hwFetchBlobData(String url) async {
  final response = await HttpRequest.request(
    url,
    responseType: 'arraybuffer',
  );

  if (response.status == 200) {
    final byteBuffer = response.response;
    return byteBuffer.asUint8List();
  } else {
    throw Exception("Failed Blob $url");
  }
}

void hwDownloadBlobData({required List blobParts, String? filename}) {
  final blob = Blob([blobParts]);
  final url = Url.createObjectUrlFromBlob(blob);
  AnchorElement(href: url)
    ..setAttribute(
        'download', '${filename ?? DateTime.now().millisecondsSinceEpoch}')
    ..click();

  // 释放 URL
  Url.revokeObjectUrl(url);
}

BaseExtendedImageProvider hwBaseExtendedFileImageProvider(String url,
    {double scale = 1.0, bool cacheRawData = false, String? imageCacheName}) {
  return BaseExtendedNetworkImageProvider(
    url,
    scale: scale,
    cacheRawData: cacheRawData,
    imageCacheName: imageCacheName,
  );
}
