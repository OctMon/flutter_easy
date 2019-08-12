import 'package:flutter_screenutil/flutter_screenutil.dart';

bool get isIPhoneX => ScreenUtil.bottomBarHeight > 0;

/// 当前设备宽度 dp
double get screenWidthDp => ScreenUtil.screenWidthDp;

/// 当前设备高度 dp
double get screenHeightDp => ScreenUtil.screenHeightDp;

/// 状态栏高度 dp 刘海屏会更高
double get screenStatusBarHeightDp => ScreenUtil.statusBarHeight;

/// 底部安全区距离 dp
double get screenBottomBarHeightDp => ScreenUtil.bottomBarHeight;

/// 根据设计稿的设备宽度适配
/// 高度也根据这个来做适配可以保证不变形
screenAutoWidth(double width) {
  return ScreenUtil.getInstance().setWidth(width);
}

/// 根据设计稿的设备高度适配
/// 当发现设计稿中的一屏显示的与当前样式效果不符合时,
/// 或者形状有差异时,高度适配建议使用此方法
/// 高度适配主要针对想根据设计稿的一屏展示一样的效果
screenAutoHeight(double height) {
  return ScreenUtil.getInstance().setHeight(height);
}
