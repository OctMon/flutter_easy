import 'dart:ui';

import 'package:flutter/material.dart';
import 'global_util.dart';

class AdaptUtil {
  static MediaQueryData mediaQuery;

  static double _width;
  static double _height;
  static double _top;
  static double _bottom;

  static double _devicePixelRatio;

  static var _ratio;

  AdaptUtil._();

  static initContext(BuildContext context) {
    if (mediaQuery == null) {
      mediaQuery = MediaQuery.of(context);
      _width = mediaQuery.size.width;
      _height = mediaQuery.size.height;
      _top = mediaQuery.padding.top;
      _bottom = mediaQuery.padding.bottom;
      _devicePixelRatio = mediaQuery.devicePixelRatio;
    }
  }

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

/// 导航栏高度 dp
double screenToolbarHeightDp = 44;

/// 底部安全区距离 dp
double screenBottomBarHeightDp = AdaptUtil.screenBottomBarHeightDp();

bool isIPhoneX = screenBottomBarHeightDp > 0;

bool _noAdapt =
    isMacOS || (isWeb && !isWebInIos && !isWebInAndroid && !isWebInWeChat);

/// 根据设计稿的比例适配dp保证不变形
adaptDp(number) {
  return _noAdapt ? double.parse('$number') : AdaptUtil.dp(number);
}

/// 根据设计稿的比例适配像素保证不变形
adaptPx(number) {
  return _noAdapt ? double.parse('$number') : AdaptUtil.px(number);
}

/// 根据设备适配1px像素大小
adaptOnePx() {
  return 1 / AdaptUtil.devicePixelRatio();
}
