import 'dart:math';

import 'package:flutter/material.dart';

var colorWithBrightness = Brightness.light;

var colorWithTint = Color(0xFFFF4040);

var colorWithAppBarTint = colorWithHex3;

var colorWithAppBarDartTint = Colors.white;

var colorWithTitle = colorWithHex3;

var colorWithAppBarBackground = Colors.white;

var colorWithAppBarDarkBackground = colorWithTint;

var colorWithScaffoldBackground = Colors.white;

var colorWithDivider = Color(0xFFEFEFF4);

const colorWithHex3 = Color(0xFF333333);

const colorWithHex6 = Color(0xFF666666);

const colorWithHex9 = Color(0xFF999999);

Color colorWithRandom() {
  int red = Random.secure().nextInt(255);
  int greed = Random.secure().nextInt(255);
  int blue = Random.secure().nextInt(255);
  return Color.fromARGB(255, red, greed, blue);
}
