import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

const bool isProduction = const bool.fromEnvironment("dart.vm.product");

final bool isDebug = _isDebug();

bool _debugFlag = false;

/// is app run a debug mode.
bool _isDebug() {
  /// Assert statements have no effect in production code;
  /// they’re for development only. Flutter enables asserts in debug mode.
  assert(() {
    _debugFlag = true;
    return _debugFlag;
  }());
  return _debugFlag;
}

bool isIOS = kIsWeb ? false : Platform.isIOS;

bool isAndroid = kIsWeb ? false : Platform.isAndroid;

bool isWeb = kIsWeb;

bool isPhone = isIOS || isAndroid;

String webAppName = "";
String webAppPackageName = "";
String webAppVersion = "";
String webAppBuildNumber = "";

/// 将文本内容复制到剪贴板
Future<void> setClipboard(String text) =>
    Clipboard.setData(ClipboardData(text: text));

/// 获取剪贴板内容
Future<String> getClipboard() =>
    Clipboard.getData(Clipboard.kTextPlain).then((data) => data.text);

/// 获取图片路径
String assetsImagesPathWebP(String name) =>
    assetsImagesPath(name, format: 'webp');

/// 获取图片路径
String assetsImagesPath(String name, {String format = "png"}) =>
    "assets/images/$name.$format";

/// 随机数(0-max)小于max
int randomInt(int max) => Random().nextInt(max);
