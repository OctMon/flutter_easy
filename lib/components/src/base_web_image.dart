import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart'
    show ImageRenderMethodForWeb;
import 'package:flutter_easy/flutter_easy.dart';

typedef BaseCachedNetworkImage = CachedNetworkImage;
typedef BaseDownloadProgress = DownloadProgress;
typedef BaseProgressIndicatorBuilder = Widget? Function(
  BuildContext context,
  String url,
  BaseDownloadProgress progress,
);

Color? baseWebImageDefaultPlaceholderColor = const Color(0xFF373839);
Widget baseWebImageDefaultErrorPlaceholder = Icon(Icons.error_outline);

class BaseWebImage extends StatelessWidget {
  final String? imageUrl;
  final Widget? placeholder;
  final Widget? errorWidget;
  final double? width;
  final double? height;
  final BoxFit? fit;

  final ValueChanged<ImageInfo?>? imageCompletionHandler;

  const BaseWebImage(this.imageUrl,
      {Key? key,
      this.placeholder,
      this.errorWidget,
      this.width,
      this.height,
      this.fit,
      this.imageCompletionHandler})
      : super(key: key);

  static Widget clip({
    String? url,
    Widget? placeholder,
    ValueChanged<ImageInfo?>? imageCompletionHandler,
    Widget? errorWidget,
    double? width,
    double? height,
    BoxFit? fit,
    double? borderRadius,
    Color? placeholderColor,
    bool round = false,
  }) {
    Widget image() {
      Widget colorWidget() {
        return placeholder ??
            Container(
              width: width,
              height: height,
              color: placeholderColor ?? baseWebImageDefaultPlaceholderColor,
            );
      }

      return Container(
        width: width,
        height: height,
        color: placeholder == null
            ? (placeholderColor ?? baseWebImageDefaultPlaceholderColor)
            : null,
        child: BaseWebImage(
          url,
          fit: fit,
          placeholder: placeholder ?? colorWidget(),
          errorWidget: errorWidget ?? colorWidget(),
          imageCompletionHandler: imageCompletionHandler,
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
    final placeholder = this.placeholder ??
        (Center(
            child: baseDefaultAnimationImage ?? CircularProgressIndicator()));
    if (imageUrl == null || imageUrl?.isEmpty == true) {
      return placeholder;
    }
    return ExtendedImage.network(
      imageUrl!,
      width: width,
      height: height,
      fit: fit,
      loadStateChanged: (ExtendedImageState state) {
        if (logEnabled) {
          logDebug(
              "loadStateChanged: $imageUrl state: ${state.extendedImageLoadState.name}");
        }
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return placeholder;
          case LoadState.completed:
            if (imageCompletionHandler != null) {
              imageCompletionHandler!(state.extendedImageInfo);
            }
            return ExtendedRawImage(
              image: state.extendedImageInfo?.image,
              width: width,
              height: height,
              fit: fit,
            );
          case LoadState.failed:
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                state.reLoadImage();
              },
              child: errorWidget ?? baseWebImageDefaultErrorPlaceholder,
            );
        }
      },
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

  static var logEnabled = false;

  /// 手动缓存文件
  static Future<File> cachePutFile(
      {required String url, required File file}) async {
    final fileBytes = await file.readAsBytesSync();

    File cacheImage = await defaultCacheManager.putFile(url, fileBytes);
    logDebug('手动缓存的图URL: $url => ${cacheImage.path}');
    return cacheImage;
  }

  static Future<File?> cacheGetFile(String url, {bool ignoreMemCache = false}) {
    return getCachedImageFile(url);
  }

  /// 删除缓存图片
  static void clean(String url) {
    clearDiskCachedImage(url);
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
