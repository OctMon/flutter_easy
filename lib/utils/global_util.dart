import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package_info_util.dart';

class GlobalUtil {
  /// 指定登录状态
  static bool Function() isLogin;

  GlobalUtil._();

  ///
  /// 初始化
  ///
  /// context: 上下文
  /// pushToLogin: 指定登录方法 [(context) => [navigateToLogin(context)]
  /// isLogin: 指定登录状态 [() => Account.isLogin]
  ///
  static Future init({dynamic Function() isLogin}) {
    GlobalUtil.isLogin = isLogin;
    return PackageInfoUtil.init();
  }
}

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

bool isIOS = Platform.isIOS;

bool isAndroid = Platform.isAndroid;

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
