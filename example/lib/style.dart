import 'package:flutter/material.dart';

import 'package:flutter_easy/flutter_easy.dart';

const colorC8 = Color(0xffC8C8C8);

void configStyle() {
  setUseSystemChineseFont = true;

  BaseDefaultConfig.defaultPickerConfig =
      BaseDefaultConfig.defaultPickerConfig.copyWith(
    backgroundColor: Colors.white,
    cornerRadius: 16,
    cancelTextStyle: TextStyle(
      fontSize: 17,
      color: colorWithHex6,
    ),
    confirmTextStyle: TextStyle(
      fontSize: 17,
      color: colorWithHex3,
    ),
    itemTextStyle: TextStyle(
      fontSize: 15,
      color: colorWithHex6,
    ),
    itemTextSelectedStyle: TextStyle(
      fontSize: 17,
      fontWeight: fontWeightMedium,
      color: setLightPrimaryColor,
    ),
  );

  BaseEasyLoading.instance
    ..loadingStyle = BaseEasyLoadingStyle.custom
    ..maskType = BaseEasyLoadingMaskType.clear
    ..contentPadding = const EdgeInsets.symmetric(horizontal: 14, vertical: 9)
    ..boxShadow = [const BoxShadow(color: Colors.transparent)]
    ..backgroundColor = Colors.black.withOpacity(0.8)
    ..progressColor = Colors.white
    ..indicatorColor = Colors.white
    ..radius = 12
    ..textColor = Colors.transparent
    ..textStyle = const TextStyle(fontSize: 17, color: Colors.white);
}
