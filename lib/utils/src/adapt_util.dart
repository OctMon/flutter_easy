import 'dart:math';

import 'package:flutter/material.dart';
import 'global_util.dart';
import 'vendor_util.dart';

/// 当前设备宽度 dp
double get screenWidthDp => BaseScreenUtil().screenWidth;

/// 当前设备高度 dp
double get screenHeightDp => BaseScreenUtil().screenHeight;

/// 状态栏高度 dp 刘海屏会更高
double get screenStatusBarHeightDp => BaseScreenUtil().statusBarHeight;

/// 导航栏高度 dp
double screenToolbarHeightDp = isIOS ? 44 : kToolbarHeight;

/// 状态栏高度+AppBar高度 dp
double get screenAppBarHeightDp =>
    screenToolbarHeightDp + screenStatusBarHeightDp;

/// 底部安全区距离 dp
double get screenBottomBarHeightDp => BaseScreenUtil().bottomBarHeight;

/// 设备的像素密度
double get screenDevicePixelRatio => BaseScreenUtil().pixelRatio ?? 1.0;

bool get isIPhoneX => screenBottomBarHeightDp > 0;

extension BaseSizeExtension on num {
  ///[ScreenUtil.setWidth]
  double get w => BaseScreenUtil().setWidth(this);

  ///[ScreenUtil.setHeight]
  double get h => BaseScreenUtil().setHeight(this);

  ///[ScreenUtil.radius]
  double get r => BaseScreenUtil().radius(this);

  ///[ScreenUtil.diagonal]
  double get dg => BaseScreenUtil().diagonal(this);

  ///[ScreenUtil.diameter]
  double get dm => BaseScreenUtil().diameter(this);

  ///[ScreenUtil.setSp]
  double get sp => BaseScreenUtil().setSp(this);

  ///smart size :  it check your value - if it is bigger than your value it will set your value
  ///for example, you have set 16.sm() , if for your screen 16.sp() is bigger than 16 , then it will set 16 not 16.sp()
  ///I think that it is good for save size balance on big sizes of screen
  double get spMin => min(toDouble(), sp);

  double get spMax => max(toDouble(), sp);

  ///屏幕宽度的倍数
  ///Multiple of screen width
  double get sw => BaseScreenUtil().screenWidth * this;

  ///屏幕高度的倍数
  ///Multiple of screen height
  double get sh => BaseScreenUtil().screenHeight * this;

  ///[ScreenUtil.setHeight]
  SizedBox get verticalSpace => BaseScreenUtil().setVerticalSpacing(this);

  ///[ScreenUtil.setVerticalSpacingFromWidth]
  SizedBox get verticalSpaceFromWidth =>
      BaseScreenUtil().setVerticalSpacingFromWidth(this);

  ///[ScreenUtil.setWidth]
  SizedBox get horizontalSpace => BaseScreenUtil().setHorizontalSpacing(this);

  ///[ScreenUtil.radius]
  SizedBox get horizontalSpaceRadius =>
      BaseScreenUtil().setHorizontalSpacingRadius(this);

  ///[ScreenUtil.radius]
  SizedBox get verticalSpacingRadius =>
      BaseScreenUtil().setVerticalSpacingRadius(this);

  ///[ScreenUtil.diameter]
  SizedBox get horizontalSpaceDiameter =>
      BaseScreenUtil().setHorizontalSpacingDiameter(this);

  ///[ScreenUtil.diameter]
  SizedBox get verticalSpacingDiameter =>
      BaseScreenUtil().setVerticalSpacingDiameter(this);

  ///[ScreenUtil.diagonal]
  SizedBox get horizontalSpaceDiagonal =>
      BaseScreenUtil().setHorizontalSpacingDiagonal(this);

  ///[ScreenUtil.diagonal]
  SizedBox get verticalSpacingDiagonal =>
      BaseScreenUtil().setVerticalSpacingDiagonal(this);
}

extension BaseEdgeInsetsExtension on EdgeInsets {
  /// Creates adapt insets using r [SizeExtension].
  EdgeInsets get r => copyWith(
        top: top.r,
        bottom: bottom.r,
        right: right.r,
        left: left.r,
      );

  EdgeInsets get dm => copyWith(
        top: top.dm,
        bottom: bottom.dm,
        right: right.dm,
        left: left.dm,
      );

  EdgeInsets get dg => copyWith(
        top: top.dg,
        bottom: bottom.dg,
        right: right.dg,
        left: left.dg,
      );

  EdgeInsets get w => copyWith(
        top: top.w,
        bottom: bottom.w,
        right: right.w,
        left: left.w,
      );

  EdgeInsets get h => copyWith(
        top: top.h,
        bottom: bottom.h,
        right: right.h,
        left: left.h,
      );
}

extension BaseBorderRadiusExtension on BorderRadius {
  /// Creates adapt BorderRadius using r [SizeExtension].
  BorderRadius get r => copyWith(
        bottomLeft: bottomLeft.r,
        bottomRight: bottomRight.r,
        topLeft: topLeft.r,
        topRight: topRight.r,
      );

  BorderRadius get w => copyWith(
        bottomLeft: bottomLeft.w,
        bottomRight: bottomRight.w,
        topLeft: topLeft.w,
        topRight: topRight.w,
      );

  BorderRadius get h => copyWith(
        bottomLeft: bottomLeft.h,
        bottomRight: bottomRight.h,
        topLeft: topLeft.h,
        topRight: topRight.h,
      );
}

extension BaseRadiusExtension on Radius {
  /// Creates adapt Radius using r [SizeExtension].
  Radius get r => Radius.elliptical(x.r, y.r);

  Radius get dm => Radius.elliptical(x.dm, y.dm);

  Radius get dg => Radius.elliptical(x.dg, y.dg);

  Radius get w => Radius.elliptical(x.w, y.w);

  Radius get h => Radius.elliptical(x.h, y.h);
}

extension BaseBoxConstraintsExtension on BoxConstraints {
  /// Creates adapt BoxConstraints using r [SizeExtension].
  BoxConstraints get r => this.copyWith(
        maxHeight: maxHeight.r,
        maxWidth: maxWidth.r,
        minHeight: minHeight.r,
        minWidth: minWidth.r,
      );

  /// Creates adapt BoxConstraints using h-w [SizeExtension].
  BoxConstraints get hw => this.copyWith(
        maxHeight: maxHeight.h,
        maxWidth: maxWidth.w,
        minHeight: minHeight.h,
        minWidth: minWidth.w,
      );

  BoxConstraints get w => this.copyWith(
        maxHeight: maxHeight.w,
        maxWidth: maxWidth.w,
        minHeight: minHeight.w,
        minWidth: minWidth.w,
      );

  BoxConstraints get h => this.copyWith(
        maxHeight: maxHeight.h,
        maxWidth: maxWidth.h,
        minHeight: minHeight.h,
        minWidth: minWidth.h,
      );
}
