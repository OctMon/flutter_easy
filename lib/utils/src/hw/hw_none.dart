dynamic sharedPreferencesInstance() =>
    throw UnsupportedError("shared preferences instance error");

String get webUserAgent => throw UnsupportedError("get web user agent error");

String get webOrigin => throw UnsupportedError("get web origin error");

/// 取缓存文件
Future<dynamic> hwCacheGetFile(String url, {String? cacheKey, String? cacheTag}) {
  return Future.value(null);
}
