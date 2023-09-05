import 'dart:async';
import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
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
var baseWebImageHandleLoadingProgress = false;

String? _keyToTagMd5(String url, String? cacheKey, String? cacheTag) {
  var _cacheKey = cacheKey;
  if (cacheTag != null) {
    if (_cacheKey != null) {
      _cacheKey = "${keyToMd5(_cacheKey)},$cacheTag";
    } else {
      _cacheKey = "${keyToMd5(url)},$cacheTag";
    }
  }
  return _cacheKey;
}

class BaseWebImage extends StatelessWidget {
  final String? imageUrl;
  final String? cacheKey;
  final String? cacheTag;
  final Widget? placeholder;
  final Widget? errorWidget;
  final double? width;
  final double? height;
  final BoxFit? fit;

  final ValueChanged<ImageInfo?>? imageCompletionHandler;

  const BaseWebImage(this.imageUrl,
      {Key? key,
      this.cacheKey,
      this.cacheTag,
      this.placeholder,
      this.errorWidget,
      this.width,
      this.height,
      this.fit,
      this.imageCompletionHandler})
      : super(key: key);

  static Widget clip({
    String? url,
    String? cacheKey,
    String? cacheTag,
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
          cacheKey: cacheKey,
          cacheTag: cacheTag,
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
      cacheKey: _keyToTagMd5(imageUrl!, cacheKey, cacheTag),
      handleLoadingProgress: baseWebImageHandleLoadingProgress,
      loadStateChanged: (BaseExtendedImageState state) {
        if (logEnabled) {
          logDebug(
              "loadStateChanged: $imageUrl state: ${state.extendedImageLoadState.name}");
        }
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            Widget loading() {
              if (baseWebImageHandleLoadingProgress) {
                final loadingProgress = state.loadingProgress;
                if (loadingProgress != null &&
                    loadingProgress.expectedTotalBytes != null)
                  return Stack(
                    children: [
                      placeholder,
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Text(
                          "${(loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!).toStringAsFixed(2)}%",
                          textAlign: TextAlign.center,
                        ).paddingOnly(bottom: 30),
                      ),
                    ],
                  );
              }
              return placeholder;
            }
            return loading();
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
  static Future<File?> cachePutFile(
      {required String url, required File file, String? cacheTag}) async {
    final String key = _keyToTagMd5(url, null, cacheTag) ?? keyToMd5(url);
    final Directory cacheImagesDirectory = Directory(
        getJoin((await getAppTemporaryDirectory()).path, cacheImageFolderName));
    if (cacheImagesDirectory.existsSync()) {
      return file.copy(getJoin(cacheImagesDirectory.path, key));
    }
    return null;
  }

  /// 取缓存文件
  static Future<File?> cacheGetFile(String url,
      {String? cacheKey, String? cacheTag}) {
    return getCachedImageFile(url,
        cacheKey: _keyToTagMd5(url, cacheKey, cacheTag));
  }

  /// get network image data from cached
  static Future<Uint8List?> getNetworkImageData(
    String url, {
    bool useCache = true,
    String? cacheKey,
    String? cacheTag,
    StreamController<ImageChunkEvent>? chunkEvents,
  }) async {
    return ExtendedNetworkImageProvider(url,
            cache: useCache, cacheKey: _keyToTagMd5(url, cacheKey, cacheTag))
        .getNetworkImageData(
      chunkEvents: chunkEvents,
    );
  }

  /// 下载图片并缓存
  static Future<File?> downloadFile(String url,
      {bool useCache = true, String? cacheKey, String? cacheTag}) async {
    await BaseWebImage.getNetworkImageData(url,
        useCache: useCache, cacheKey: cacheKey, cacheTag: cacheTag);
    return getCachedImageFile(url,
        cacheKey: _keyToTagMd5(url, cacheKey, cacheTag));
  }

  /// 删除缓存图片
  static void clean(String url, {String? cacheKey, String? cacheTag}) {
    clearDiskCachedImage(url, cacheKey: _keyToTagMd5(url, cacheKey, cacheTag));
  }

  /// Clear the disk cache directory then return if it succeed.
  static Future<bool> clearDiskCachedImages(
      {Duration? duration, String? cacheTag}) async {
    try {
      final Directory cacheImagesDirectory = Directory(getJoin(
          (await getAppTemporaryDirectory()).path, cacheImageFolderName));
      if (cacheImagesDirectory.existsSync()) {
        final DateTime now = DateTime.now();
        await for (final FileSystemEntity file in cacheImagesDirectory.list()) {
          final FileStat fs = file.statSync();

          void deleteSync() {
            var flag = false;
            if (cacheTag != null) {
              if (getBasenameWithoutExtension(file.path).contains(cacheTag)) {
                flag = true;
                file.deleteSync(recursive: true);
              }
            } else {
              flag = true;
              file.deleteSync(recursive: true);
            }
            logDebug(
                "delete: ${duration?.inSeconds}s - ${fs.changed} - ${getBasenameWithoutExtension(file.path)} - $flag");
          }

          if (duration == null) {
            deleteSync();
          } else {
            if (now.subtract(duration).isAfter(fs.changed)) {
              deleteSync();
            }
          }
        }
      }
    } catch (_) {
      return false;
    }
    return true;
  }
}
