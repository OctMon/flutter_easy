import 'dart:async';
import 'dart:io';

import 'package:extended_image/extended_image.dart';

import '../../utils/src/hw/hw_mp.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

Color? baseWebImageDefaultPlaceholderColor = const Color(0xFF373839);
Widget baseWebImageDefaultErrorPlaceholder = Icon(Icons.error_outline);
var baseWebImageHandleLoadingProgress = false;
Duration? baseWebImageDefaultTimeLimit;

/// 图片前缀，用于拼接图片地址
String? kWebImagePrefix;

class BaseWebImage extends StatelessWidget {
  final String? imageUrl;
  final String? cacheKey;
  final String? cacheTag;
  final Widget? placeholder;
  final Widget? errorWidget;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final int retries;
  final Duration? timeLimit;
  final Map<String, String>? headers;

  final ValueChanged<ImageInfo?>? imageCompletionHandler;

  const BaseWebImage(this.imageUrl,
      {super.key,
      this.cacheKey,
      this.cacheTag,
      this.placeholder,
      this.errorWidget,
      this.width,
      this.height,
      this.fit,
      this.imageCompletionHandler,
      this.retries = 3,
      this.timeLimit,
      this.headers});

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
    int retries = 3,
    Duration? timeLimit,
    Map<String, String>? headers,
    double? borderRadius,
    BoxBorder? border,
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
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: placeholder == null
              ? (placeholderColor ?? baseWebImageDefaultPlaceholderColor)
              : null,
          borderRadius:
              borderRadius != null ? BorderRadius.circular(borderRadius) : null,
        ),
        child: BaseWebImage(
          url,
          cacheKey: cacheKey,
          cacheTag: cacheTag,
          width: width,
          height: height,
          fit: fit,
          retries: retries,
          timeLimit: timeLimit,
          headers: headers,
          placeholder: placeholder ?? colorWidget(),
          errorWidget: errorWidget ?? colorWidget(),
          imageCompletionHandler: imageCompletionHandler,
        ),
      );
    }

    if (round || borderRadius != null) {
      return Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            (round && width != null) ? width * 0.5 : (borderRadius ?? 0),
          ),
          border: border,
        ),
        child: image(),
      );
    }
    return image();
  }

  @override
  Widget build(BuildContext context) {
    final placeholder = this.placeholder ??
        (Center(child: baseDefaultAnimationImage ?? BaseLoadingView()));
    if (imageUrl == null || imageUrl?.isEmpty == true) {
      return placeholder;
    }

    var img = imageUrl!;
    if (kWebImagePrefix != null && !img.startsWith("http")) {
      img = getJoin(kWebImagePrefix!, img);
    }

    if (!img.startsWith("http")) {
      return Image.file(
        File(img),
        width: width,
        height: height,
        fit: fit,
      );
    }

    return BaseExtendedImage.network(
      img,
      width: width,
      height: height,
      fit: fit,
      cacheKey: keyToTagMd5(img, cacheKey, cacheTag),
      timeLimit: timeLimit ?? baseWebImageDefaultTimeLimit,
      retries: retries,
      headers: headers,
      handleLoadingProgress: baseWebImageHandleLoadingProgress,
      loadStateChanged: (BaseExtendedImageState state) {
        if (logEnabled) {
          logDebug(
              "loadStateChanged: $img state: ${state.extendedImageLoadState.name}");
        }
        switch (state.extendedImageLoadState) {
          case BaseLoadState.loading:
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
                          "${(loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! * 100).toStringAsFixed(0)}%",
                          textAlign: TextAlign.center,
                        ).paddingOnly(bottom: 30),
                      ),
                    ],
                  );
              }
              return placeholder;
            }
            return loading();
          case BaseLoadState.completed:
            if (imageCompletionHandler != null) {
              imageCompletionHandler!(state.extendedImageInfo);
            }
            if (state.wasSynchronouslyLoaded) {
              return state.completedWidget;
            }
            return null;
          case BaseLoadState.failed:
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

  static String? keyToTagMd5(String url, String? cacheKey, String? cacheTag) {
    var _cacheKey = cacheKey;
    if (cacheTag != null) {
      if (_cacheKey != null) {
        _cacheKey = "${_cacheKey.md5},$cacheTag";
      } else {
        _cacheKey = "${url.md5},$cacheTag";
      }
    }
    return _cacheKey;
  }

  /// 手动缓存文件
  static Future<File?> cachePutFile(
      {required String url, required File file, String? cacheTag}) async {
    final String key = keyToTagMd5(url, null, cacheTag) ?? url.md5;
    final Directory cacheImagesDirectory = Directory(
        getJoin((await getAppTemporaryDirectory()).path, cacheImageFolderName));
    if (cacheImagesDirectory.existsSync()) {
      return file.copy(getJoin(cacheImagesDirectory.path, key));
    }
    return null;
  }

  /// 取缓存文件
  static Future<File?> cacheGetFile(String url,
      {String? cacheKey, String? cacheTag}) async {
    return await hwCacheGetFile(url,
        cacheKey: keyToTagMd5(url, cacheKey, cacheTag));
  }

  /// get network image data from cached
  static Future<Uint8List?> getNetworkImageData(
    String url, {
    bool useCache = true,
    String? cacheKey,
    String? cacheTag,
    StreamController<ImageChunkEvent>? chunkEvents,
  }) async {
    return BaseExtendedNetworkImageProvider(url,
            cache: useCache, cacheKey: keyToTagMd5(url, cacheKey, cacheTag))
        .getNetworkImageData(
      chunkEvents: chunkEvents,
    );
  }

  /// 下载图片并缓存
  static Future<File?> downloadFile(String url,
      {bool useCache = true, String? cacheKey, String? cacheTag}) async {
    await BaseWebImage.getNetworkImageData(url,
        useCache: useCache, cacheKey: cacheKey, cacheTag: cacheTag);
    return await cacheGetFile(url,
        cacheKey: keyToTagMd5(url, cacheKey, cacheTag));
  }

  /// 删除缓存图片
  static void clean(String url, {String? cacheKey, String? cacheTag}) {
    clearDiskCachedImage(url, cacheKey: keyToTagMd5(url, cacheKey, cacheTag));
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
