import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

var setLightScaffoldBackgroundColor = Colors.white;
var setDarkScaffoldBackgroundColor = Colors.black;

var setLightPrimaryColor = Colors.red;
var setDarkPrimaryColor = Colors.purple;

var setLightPrimarySwatchColor = colorWithHex3;
var setDarkPrimarySwatchColor = Colors.white;

var setLightAppBarBackgroundColor = Colors.white;
var setDarkAppBarBackgroundColor = Colors.black;

var setLightAppBarForegroundColor = colorWithHex3;
var setDarkAppBarForegroundColor = Colors.white;

var setLightBodyText2Style = TextStyle(
  color: colorWithHex3,
);
var setDarkBodyText2Style = TextStyle(
  color: Colors.white,
);

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
      primary:
          darkMode ? setDarkPrimarySwatchColor : setLightPrimarySwatchColor,
    ),
    primaryColor: darkMode ? setDarkPrimaryColor : setLightPrimaryColor,
    // 页面背景色
    scaffoldBackgroundColor: darkMode
        ? setDarkScaffoldBackgroundColor
        : setLightScaffoldBackgroundColor,
    // Tab指示器颜色
    indicatorColor: darkMode ? setDarkPrimaryColor : setLightPrimaryColor,
    appBarTheme: AppBarTheme(
      elevation: 0.0,
      foregroundColor: darkMode
          ? setDarkAppBarForegroundColor
          : setLightAppBarForegroundColor,
      color: darkMode
          ? setDarkAppBarBackgroundColor
          : setLightAppBarBackgroundColor,
      systemOverlayStyle:
          darkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
    ),
    textTheme: TextTheme(
      bodyText2: darkMode ? setDarkBodyText2Style : setLightBodyText2Style,
    ),
  );
}
