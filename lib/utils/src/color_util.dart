import 'dart:math';

import 'package:flutter/material.dart';

var colorWithBrightness = Brightness.light;

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

var colorWithScaffoldBackground = Colors.white;

var colorWithDivider = Color(0xFFEFEFF4);

const colorWithHex3 = Color(0xFF333333);

const colorWithHex6 = Color(0xFF666666);

const colorWithHex7 = Color(0xFF777777);

const colorWithHex9 = Color(0xFF999999);

const colorWithHexC = Color(0xFFCCCCCC);

Color colorWithRandom() {
  int red = Random.secure().nextInt(255);
  int greed = Random.secure().nextInt(255);
  int blue = Random.secure().nextInt(255);
  return Color.fromARGB(255, red, greed, blue);
}
