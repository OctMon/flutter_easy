import 'package:flutter/material.dart';
import 'global_util.dart';

class AdaptUtil {
  static MediaQueryData? mediaQuery;

  static double _width = 375;
  static double _height = 812;
  static double _top = 0;
  static double _bottom = 0;

  static late double _devicePixelRatio;

  static var _ratio;

  AdaptUtil._();

  static initContext(BuildContext context) {
    if (!MediaQuery.of(context).size.isEmpty) {
      mediaQuery = MediaQuery.of(context);
      _width = mediaQuery!.size.width;
      _height = mediaQuery!.size.height;
      _top = mediaQuery!.padding.top;
      _bottom = mediaQuery!.padding.bottom;
      _devicePixelRatio = mediaQuery!.devicePixelRatio;
    }
  }

  static init(int? number) {
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
double get screenWidthDp => AdaptUtil.screenWidthDp();

/// 当前设备高度 dp
double get screenHeightDp => AdaptUtil.screenHeightDp();

/// 状态栏高度 dp 刘海屏会更高
double get screenStatusBarHeightDp => AdaptUtil.screenStatusBarHeightDp();

/// 导航栏高度 dp
double screenToolbarHeightDp = isIOS ? 44 : kToolbarHeight;

/// 状态栏高度+AppBar高度 dp
double get screenAppBarHeightDp =>
    screenToolbarHeightDp + screenStatusBarHeightDp;

/// 底部安全区距离 dp
double get screenBottomBarHeightDp => AdaptUtil.screenBottomBarHeightDp();

/// The number of device pixels for each logical pixe
double screenDevicePixelRatio = AdaptUtil.devicePixelRatio();

bool get isIPhoneX => screenBottomBarHeightDp > 0;

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
