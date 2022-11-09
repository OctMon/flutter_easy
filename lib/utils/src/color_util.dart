import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

var setLightScaffoldBackgroundColor = Colors.white;
var setDarkScaffoldBackgroundColor = Colors.black;

Color setLightPrimaryColor = Colors.red;
Color setDarkPrimaryColor = Colors.purple;

var setLightPrimarySwatchColor = colorWithHex3;
var setDarkPrimarySwatchColor = Colors.blue;

var setLightAppBarSystemOverlayStyle = SystemUiOverlayStyle.dark;
var setDarkAppBarSystemOverlayStyle = SystemUiOverlayStyle.light;

var setLightAppBarBackgroundColor = Colors.white;
var setDarkAppBarBackgroundColor = Colors.black;

var setLightAppBarForegroundColor = colorWithHex3;
var setDarkAppBarForegroundColor = Colors.white;

var setLightDividerColor = Color(0x1FFFFFFF);
var setDarkDividerColor = Color(0xFFEFEFF4);

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

var setLightBodyText2Style = TextStyle(
  color: colorWithHex3,
);
var setDarkBodyText2Style = TextStyle(
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

var setLightPlaceholderTextStyle = TextStyle(
  color: colorWithHex9,
  fontSize: 15,
);
var setDarkPlaceholderTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 15,
);

Color colorWithLightSecondary = Colors.tealAccent;
Color colorWithDarkSecondary = Colors.blueAccent;

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
    ),
    textTheme: TextTheme(
      // 默认 Text 样式
      bodyText2: darkMode ? setDarkBodyText2Style : setLightBodyText2Style,
    ),
  );
}
