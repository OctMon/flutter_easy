import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

var colorWithBrightness = Brightness.light;

var colorLightScaffoldBackground = Colors.white;
var colorDarkScaffoldBackground = Colors.black;

var colorLightPrimaryColor = Colors.red;
var colorDarkPrimaryColor = Colors.purple;

var colorWithTint = Color(0xFFFF4040);

var colorWithPrimary1 = Color(0xFF00B247);

var colorWithPrimary2 = Color(0xFF2B7CFF);

var colorWithPrimary3 = Color(0xFFE6A23C);

var colorWithAppBarLightTint = colorWithHex3;

var colorWithAppBarDartTint = Colors.white;

var colorWithTitle = colorWithHex3;

var colorWithText1 = Color(0xff303133);

var colorWithText2 = Color(0xff606266);

var colorWithText3 = Color(0xff909399);

var colorWithAppBarLightBackground = Colors.white;

var colorWithAppBarDarkBackground = colorWithTint;

var colorWithDivider = Color(0xFFEFEFF4);

const colorWithHex3 = Color(0xFF333333);

const colorWithHex4 = Color(0xFF444444);

const colorWithHex5 = Color(0xFF555555);

const colorWithHex6 = Color(0xFF666666);

const colorWithHex7 = Color(0xFF777777);

const colorWithHex8 = Color(0xFF888888);

const colorWithHex9 = Color(0xFF999999);

const colorWithHexA = Color(0xFFAAAAAA);

const colorWithHexB = Color(0xFFBBBBBB);

const colorWithHexC = Color(0xFFCCCCCC);

const colorWithHexD = Color(0xFFDDDDDD);

const colorWithHexE = Color(0xFFEEEEEE);

bool get appDarkMode => Get.isDarkMode;

Color colorWithRandom() {
  int red = Random.secure().nextInt(255);
  int greed = Random.secure().nextInt(255);
  int blue = Random.secure().nextInt(255);
  return Color.fromARGB(255, red, greed, blue);
}

ThemeData getTheme({bool darkMode = false}) {
  return ThemeData(
    platform: TargetPlatform.iOS,
    splashColor: Colors.transparent,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      brightness: darkMode ? Brightness.dark : Brightness.light,
    ),
    primaryColor: darkMode ? colorDarkPrimaryColor : colorLightPrimaryColor,
    // 页面背景色
    scaffoldBackgroundColor:
        darkMode ? colorDarkScaffoldBackground : colorLightScaffoldBackground,
    // Tab指示器颜色
    indicatorColor: darkMode ? colorDarkPrimaryColor : colorLightPrimaryColor,
  );
}
