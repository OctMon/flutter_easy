import 'package:flutter/material.dart';

import '../../flutter_easy.dart';

class BaseDefaultConfig {
  const BaseDefaultConfig._();

  static BasePickerConfig defaultPickerConfig = BasePickerConfig(
    backgroundColor: Colors.white,
    cancelTextStyle: TextStyle(color: colorWithHex6, fontSize: 17),
    confirmTextStyle: TextStyle(
      color: colorWithHex3,
      fontSize: 17,
    ),
    titleTextStyle: TextStyle(
      color: colorWithHex3,
      fontSize: 17,
      fontWeight: FontWeight.w600,
    ),
    pickerHeight: 240.0,
    titleHeight: 48.0,
    itemHeight: 48.0,
    dividerColor: Color(0xFFF0F0F0),
    itemTextStyle: TextStyle(color: colorWithHex3, fontSize: 15),
    itemTextSelectedStyle: TextStyle(
      color: Get.theme.primaryColor,
      fontSize: 17,
      fontWeight: FontWeight.w600,
    ),
    cornerRadius: 8,
  );
}
