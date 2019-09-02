import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package_info_utils.dart';

class GlobalUtils {
  /// 上下文
  static BuildContext context;

  /// 指定登录方法
  static Future<dynamic> Function(BuildContext context) pushToLogin;

  /// 指定登录状态
  static bool Function() isLogin;

  GlobalUtils._();

  ///
  /// 设置全局上下文
  ///
  /// context: 上下文
  ///
  static void setContext(BuildContext context,
      {Future<dynamic> Function(BuildContext context) pushToLogin,
      dynamic Function() isLogin,
      double width = 375,
      double height = 667,
      bool allowFontScaling = false}) {
    GlobalUtils.pushToLogin = pushToLogin;
    GlobalUtils.isLogin = isLogin;
    PackageInfoUtils.init();
    GlobalUtils.context = context;
    // 在使用之前请设置好设计稿的宽度和高度，传入设计稿的宽度和高度(单位px) 一定在MaterialApp的home中的页面设置(即入口文件，只需设置一次),以保证在每次使用之前设置好了适配尺寸:
    ScreenUtil.instance = ScreenUtil(
      width: width,
      height: height,
    )..init(context);
  }
}

const bool isProduction = const bool.fromEnvironment("dart.vm.product");

bool get isIOS => Platform.isIOS;

bool get isAndroid => Platform.isAndroid;

/// 获取图片路径
String assetsImagesPath(String name, {String format = "png"}) =>
    "assets/images/$name.$format";
