import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../extension/src/font_extensions.dart';

Color setLightScaffoldBackgroundColor = Colors.white;
Color setDarkScaffoldBackgroundColor = Colors.black;

Color setLightPrimaryColor = Colors.red;
Color setDarkPrimaryColor = Colors.purple;

Color setLightPrimarySwatchColor = colorWithHex3;
Color setDarkPrimarySwatchColor = Colors.blue;

var setLightAppBarSystemOverlayStyle = SystemUiOverlayStyle.dark;
var setDarkAppBarSystemOverlayStyle = SystemUiOverlayStyle.light;

bool? setAppBarCenterTitle;

Color setLightAppBarBackgroundColor = Colors.white;
Color setDarkAppBarBackgroundColor = Colors.black;

Color setLightAppBarForegroundColor = colorWithHex3;
Color setDarkAppBarForegroundColor = Colors.white;

Color setLightDividerColor = Color(0x1FFFFFFF);
Color setDarkDividerColor = Color(0xFFEFEFF4);

TargetPlatform? setTargetPlatform;

var setLightAppBarTitleTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w500,
  color: colorWithHex3,
);
var setDarkAppBarTitleTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w500,
  color: Colors.white,
);

var setLightBodyMediumStyle = TextStyle(
  color: colorWithHex3,
);
var setDarkBodyMediumStyle = TextStyle(
  color: Colors.white,
);

var setLightTextFieldStyle = TextStyle(
  color: colorWithHex3,
);
var setDarkTextFieldStyle = TextStyle(
  color: Colors.white,
);

var setLightPlaceholderTextFieldStyle = TextStyle(
  color: colorWithHex9,
);
var setDarkPlaceholderTextFieldStyle = TextStyle(
  color: colorWithHex9,
);

var setLightPlaceholderTitleTextStyle = TextStyle(
  color: colorWithHex9,
  fontSize: 28,
  fontWeight: fontWeightBold,
);
var setDarkPlaceholderTitleTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 28,
  fontWeight: fontWeightBold,
);
var setLightPlaceholderMessageTextStyle = TextStyle(
  color: colorWithHex9,
  fontSize: 17,
);
var setDarkPlaceholderMessageTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 17,
);

Color colorWithLightSecondary = Colors.tealAccent;
Color colorWithDarkSecondary = Colors.blueAccent;

String? setThemeDataFontFamily;

const colorWithHex2 = Color(0xFF222222);

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

ThemeData appTheme(BuildContext context) => Theme.of(context);

bool appDarkMode(BuildContext context) =>
    appTheme(context).brightness == Brightness.dark;

Color colorWithRandom() {
  int red = Random.secure().nextInt(255);
  int greed = Random.secure().nextInt(255);
  int blue = Random.secure().nextInt(255);
  return Color.fromARGB(255, red, greed, blue);
}

ThemeData getTheme({bool darkMode = false, required bool useMaterial3}) {
  return ThemeData(
    useMaterial3: useMaterial3,
    platform: setTargetPlatform,
    splashColor: Colors.transparent,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      brightness: darkMode ? Brightness.dark : Brightness.light,
      primary:
          darkMode ? setDarkPrimarySwatchColor : setLightPrimarySwatchColor,
      surfaceTint: Colors.transparent,
    ),
    primaryColor: darkMode ? setDarkPrimaryColor : setLightPrimaryColor,
    // 页面背景色
    scaffoldBackgroundColor: darkMode
        ? setDarkScaffoldBackgroundColor
        : setLightScaffoldBackgroundColor,
    // Tab指示器颜色
    indicatorColor: darkMode ? setDarkPrimaryColor : setLightPrimaryColor,
    dividerColor: darkMode ? setDarkDividerColor : setLightDividerColor,
    appBarTheme: AppBarTheme(
      elevation: 0.0,
      foregroundColor: darkMode
          ? setDarkAppBarForegroundColor
          : setLightAppBarForegroundColor,
      color: darkMode
          ? setDarkAppBarBackgroundColor
          : setLightAppBarBackgroundColor,
      systemOverlayStyle: darkMode
          ? setDarkAppBarSystemOverlayStyle
          : setLightAppBarSystemOverlayStyle,
      titleTextStyle:
          darkMode ? setDarkAppBarTitleTextStyle : setLightAppBarTitleTextStyle,
      centerTitle: setAppBarCenterTitle,
    ),
    fontFamily: setThemeDataFontFamily,
    textTheme: TextTheme(
      // 默认 Text 样式
      bodyMedium: darkMode ? setDarkBodyMediumStyle : setLightBodyMediumStyle,
    ),
  );
}
