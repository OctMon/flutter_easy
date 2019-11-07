import 'dart:ui';

import 'package:flutter/material.dart';

class AdaptUtil {
  static MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);
  static double _width = mediaQuery.size.width;
  static double _height = mediaQuery.size.height;
  static double _top = mediaQuery.padding.top;
  static double _bottom = mediaQuery.padding.bottom;
  static double _devicePixelRatio = mediaQuery.devicePixelRatio;
  static var _ratio;

  AdaptUtil._();

  static init(int number) {
    int uiWidth = number is int ? number : 750;
    _ratio = _width / uiWidth;
  }

  static px(number) {
    if (!(_ratio is double || _ratio is int)) {
      AdaptUtil.init(750);
    }
    return number * _ratio;
  }

  static dp(number) {
    return px(number * 2);
  }

  static screenWidthDp() {
    return _width;
  }

  static screenHeightDp() {
    return _height;
  }

  static screenStatusBarHeightDp() {
    return _top;
  }

  static screenBottomBarHeightDp() {
    return _bottom;
  }

  static devicePixelRatio() {
    return _devicePixelRatio;
  }
}

/// 当前设备宽度 dp
double screenWidthDp = AdaptUtil.screenWidthDp();

/// 当前设备高度 dp
double screenHeightDp = AdaptUtil.screenHeightDp();

/// 状态栏高度 dp 刘海屏会更高
double screenStatusBarHeightDp = AdaptUtil.screenStatusBarHeightDp();

/// 底部安全区距离 dp
double screenBottomBarHeightDp = AdaptUtil.screenBottomBarHeightDp();

bool isIPhoneX = screenBottomBarHeightDp > 0;

/// 根据设计稿的比例适配dp保证不变形
adaptDp(number) {
  return AdaptUtil.dp(number);
}

/// 根据设计稿的比例适配像素保证不变形
adaptPx(number) {
  return AdaptUtil.px(number);
}

/// 根据设备适配1px像素大小
adaptOnePx() {
  return 1 / AdaptUtil.devicePixelRatio();
}
