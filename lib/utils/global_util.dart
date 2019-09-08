import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package_info_util.dart';

class GlobalUtil {
  /// 指定登录方法
  static Future<dynamic> Function(BuildContext context) pushToLogin;

  /// 指定登录状态
  static bool Function() isLogin;

  GlobalUtil._();

  ///
  /// 初始化
  ///
  /// context: 上下文
  /// pushToLogin: 指定登录方法 [(context) => [navigateToLogin(context)]
  /// isLogin: 指定登录状态 [() => Account.isLogin]
  /// width: 在使用之前请设置好设计稿的宽度
  /// height: 在使用之前请设置好设计稿的高度
  ///
  static void init(BuildContext context,
      {Future<dynamic> Function(BuildContext context) pushToLogin,
      dynamic Function() isLogin,
      double width = 375,
      double height = 667,
      bool allowFontScaling = false}) {
    GlobalUtil.pushToLogin = pushToLogin;
    GlobalUtil.isLogin = isLogin;
    PackageInfoUtil.init();
    // 在使用之前请设置好设计稿的宽度和高度，传入设计稿的宽度和高度(单位px) 一定在MaterialApp的home中的页面设置(即入口文件，只需设置一次),以保证在每次使用之前设置好了适配尺寸:
    ScreenUtil.instance = ScreenUtil(
      width: width,
      height: height,
    )..init(context);
  }
}

const bool isProduction = const bool.fromEnvironment("dart.vm.product");

bool isIOS = Platform.isIOS;

bool isAndroid = Platform.isAndroid;

/// 将文本内容复制到剪贴板
Future<void> setClipboard(String text) =>
    Clipboard.setData(ClipboardData(text: text));

/// 获取剪贴板内容
Future<String> getClipboard() =>
    Clipboard.getData(Clipboard.kTextPlain).then((data) => data.text);

/// 获取图片路径
String assetsImagesPath(String name, {String format = "png"}) =>
    "assets/images/$name.$format";
