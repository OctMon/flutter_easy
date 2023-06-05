import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart'
    show ImageRenderMethodForWeb;
import 'package:flutter_easy/flutter_easy.dart';

// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as p;

Color? baseDefaultPlaceholderColor = const Color(0xFF373839);

class BaseWebImage extends StatelessWidget {
  final String? imageUrl;
  final Widget placeholder;
  final Widget? errorWidget;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const BaseWebImage(this.imageUrl,
      {Key? key,
      this.placeholder = const Center(child: CircularProgressIndicator()),
      this.errorWidget,
      this.width,
      this.height,
      this.fit})
      : super(key: key);

  static Widget clip({
    String? url,
    Widget? placeholder,
    Widget? errorWidget,
    double? width,
    double? height,
    BoxFit? fit,
    double? borderRadius,
    Color? placeholderColor,
    bool round = false,
  }) {
    Widget image() {
      return Container(
        width: width,
        height: height,
        color: placeholder == null
            ? (placeholderColor ?? baseDefaultPlaceholderColor)
            : null,
        child: BaseWebImage(
          url,
          fit: fit,
          placeholder: placeholder ??
              Container(
                width: width,
                height: height,
                color: placeholderColor ?? baseDefaultPlaceholderColor,
              ),
        ),
      );
    }

    if (round || borderRadius != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(
          (round && width != null) ? width * 0.5 : (borderRadius ?? 0),
        ),
        child: image(),
      );
    }
    return image();
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl?.isEmpty == true) {
      return placeholder;
    }
    return CachedNetworkImage(
      // cacheManager: DefaultCacheManager(),
      imageUrl: imageUrl!,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => placeholder,
      errorWidget: (context, url, error) => errorWidget ?? placeholder,
    );
  }

  static ImageProvider<CachedNetworkImageProvider> provider(
    String url, {
    double scale = 1.0,
    Map<String, String>? headers,
    BaseCacheManager? cacheManager,
    ImageRenderMethodForWeb imageRenderMethodForWeb =
        ImageRenderMethodForWeb.HtmlImage,
  }) {
    return CachedNetworkImageProvider(url,
        scale: scale,
        headers: headers,
        cacheManager: cacheManager,
        imageRenderMethodForWeb: imageRenderMethodForWeb);
  }

  static ImageCacheManager get defaultCacheManager => DefaultCacheManager();

  /// 手动缓存文件
  static Future<File> cachePutFile(
      {required String url, required File file}) async {
    final fileBytes = await file.readAsBytesSync();

    File cacheImage = await defaultCacheManager.putFile(url, fileBytes);
    logDebug('手动缓存的图URL: $url => ${cacheImage.path}');
    return cacheImage;
  }

  /// 删除缓存图片
  static void clean(String url) {
    defaultCacheManager.removeFile(url);
  }
}

/*class DefaultCacheManager extends BaseCacheManager {
  static const key = "cachedImageData";

  static DefaultCacheManager _instance;

  /// The DefaultCacheManager that can be easily used directly. The code of
  /// this implementation can be used as inspiration for more complex cache
  /// managers.
  factory DefaultCacheManager() {
    if (_instance == null) {
      _instance = new DefaultCacheManager._();
    }
    return _instance;
  }

  DefaultCacheManager._() : super(key, maxAgeCacheObject: Duration(days: 30));

  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return p.join(directory.path, key);
  }
}*/
