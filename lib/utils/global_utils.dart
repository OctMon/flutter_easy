import 'dart:io';
import 'package:flutter/material.dart';

class GlobalUtils {
  /// 上下文
  static BuildContext context;

  GlobalUtils._();

  ///
  /// 设置全局上下文
  ///
  /// context: 上下文
  ///
  static void setContext(BuildContext context) {
    GlobalUtils.context = context;
  }
}

const bool isProduction = const bool.fromEnvironment("dart.vm.product");

bool get isIOS => Platform.isIOS;

bool get isAndroid => Platform.isAndroid;

/// 获取图片路径
String assetsImagesPath(String name, {String format = "png"}) =>
    "assets/images/$name.$format";
