import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

typedef BaseExtendedImage = ExtendedImage;
typedef BaseExtendedImageState = ExtendedImageState;
typedef BaseExtendedFileImageProvider = ExtendedFileImageProvider;
typedef BaseExtendedNetworkImageProvider = ExtendedNetworkImageProvider;
typedef BaseExtendedAssetImageProvider = ExtendedAssetImageProvider;
typedef BaseExtendedExactAssetImageProvider = ExtendedExactAssetImageProvider;

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
    return BaseExtendedImage.network(
      imageUrl!,
      width: width,
      height: height,
      fit: fit,
      loadStateChanged: (BaseExtendedImageState state) {
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
            if (state.wasSynchronouslyLoaded) {
              return state.completedWidget;
            }
            return null;
          case LoadState.failed:
            //remove memory cached
            state.imageProvider.evict();
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

  static var logEnabled = false;

  /// 手动缓存文件
  static BaseExtendedFileImageProvider cachePutFile(
      {required String url, required File file}) {
    return ExtendedFileImageProvider(file,
        cacheRawData: true, imageCacheName: keyToMd5(url));
  }

  /// 取缓存文件
  static Future<File?> cacheGetFile(String url, {String? cacheKey}) {
    return getCachedImageFile(url, cacheKey: cacheKey);
  }

  /// 下载图片并缓存
  static Future<File?> downloadFile(String url, {bool useCache = true}) async {
    await getNetworkImageData(url, useCache: useCache);
    return getCachedImageFile(url);
  }

  /// 删除缓存图片
  static void clean(String url) {
    clearDiskCachedImage(url);
  }
}
