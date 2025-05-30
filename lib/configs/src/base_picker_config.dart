import 'package:flutter/material.dart';

import 'base_default_config.dart';

class BasePickerConfig {
  BasePickerConfig({
    Color? backgroundColor,
    TextStyle? cancelTextStyle,
    TextStyle? confirmTextStyle,
    TextStyle? titleTextStyle,
    double? pickerHeight,
    double? titleHeight,
    double? itemHeight,
    TextStyle? itemTextStyle,
    TextStyle? itemTextSelectedStyle,
    Color? dividerColor,
    double? cornerRadius,
  })  : _backgroundColor = backgroundColor,
        _cancelTextStyle = cancelTextStyle,
        _confirmTextStyle = confirmTextStyle,
        _titleTextStyle = titleTextStyle,
        _pickerHeight = pickerHeight,
        _titleHeight = titleHeight,
        _itemHeight = itemHeight,
        _itemTextStyle = itemTextStyle,
        _itemTextSelectedStyle = itemTextSelectedStyle,
        _dividerColor = dividerColor,
        _cornerRadius = cornerRadius;

  /// 日期选择器的背景色
  Color? _backgroundColor;

  /// 取消文字的样式
  TextStyle? _cancelTextStyle;

  /// 确认文字的样式
  TextStyle? _confirmTextStyle;

  /// 标题文字的样式
  TextStyle? _titleTextStyle;

  /// 日期选择器的高度
  double? _pickerHeight;

  /// 日期选择器标题的高度
  double? _titleHeight;

  /// 日期选择器列表的高度
  double? _itemHeight;

  /// 日期选择器列表的文字样式
  TextStyle? _itemTextStyle;

  /// 日期选择器列表选中的文字样式
  TextStyle? _itemTextSelectedStyle;

  Color? _dividerColor;
  double? _cornerRadius;

  Color get backgroundColor =>
      _backgroundColor ??
      BaseDefaultConfig.defaultPickerConfig.backgroundColor;

  TextStyle get cancelTextStyle =>
      _cancelTextStyle ??
      BaseDefaultConfig.defaultPickerConfig.cancelTextStyle;

  TextStyle get confirmTextStyle =>
      _confirmTextStyle ??
      BaseDefaultConfig.defaultPickerConfig.confirmTextStyle;

  TextStyle get titleTextStyle =>
      _titleTextStyle ??
      BaseDefaultConfig.defaultPickerConfig.titleTextStyle;

  double get pickerHeight =>
      _pickerHeight ?? BaseDefaultConfig.defaultPickerConfig.pickerHeight;

  double get titleHeight =>
      _titleHeight ?? BaseDefaultConfig.defaultPickerConfig.titleHeight;

  double get itemHeight =>
      _itemHeight ?? BaseDefaultConfig.defaultPickerConfig.itemHeight;

  TextStyle get itemTextStyle =>
      _itemTextStyle ?? BaseDefaultConfig.defaultPickerConfig.itemTextStyle;

  TextStyle get itemTextSelectedStyle =>
      _itemTextSelectedStyle ??
      BaseDefaultConfig.defaultPickerConfig.itemTextSelectedStyle;

  Color get dividerColor =>
      _dividerColor ?? BaseDefaultConfig.defaultPickerConfig.dividerColor;

  double get cornerRadius =>
      _cornerRadius ?? BaseDefaultConfig.defaultPickerConfig.cornerRadius;

  BasePickerConfig copyWith({
    Color? backgroundColor,
    TextStyle? cancelTextStyle,
    TextStyle? confirmTextStyle,
    TextStyle? titleTextStyle,
    double? pickerHeight,
    double? titleHeight,
    double? itemHeight,
    TextStyle? itemTextStyle,
    TextStyle? itemTextSelectedStyle,
    Color? dividerColor,
    double? cornerRadius,
  }) {
    return BasePickerConfig(
      backgroundColor: backgroundColor ?? _backgroundColor,
      cancelTextStyle: cancelTextStyle ?? _cancelTextStyle,
      confirmTextStyle: confirmTextStyle ?? _confirmTextStyle,
      titleTextStyle: titleTextStyle ?? _titleTextStyle,
      pickerHeight: pickerHeight ?? _pickerHeight,
      titleHeight: titleHeight ?? _titleHeight,
      itemHeight: itemHeight ?? _itemHeight,
      itemTextStyle: itemTextStyle ?? _itemTextStyle,
      itemTextSelectedStyle: itemTextSelectedStyle ?? _itemTextSelectedStyle,
      dividerColor: dividerColor ?? _dividerColor,
      cornerRadius: cornerRadius ?? _cornerRadius,
    );
  }

  BasePickerConfig merge(BasePickerConfig? other) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other._backgroundColor,
      cancelTextStyle: cancelTextStyle.merge(other._cancelTextStyle),
      confirmTextStyle: confirmTextStyle.merge(other._confirmTextStyle),
      titleTextStyle: titleTextStyle.merge(other._titleTextStyle),
      pickerHeight: other._pickerHeight,
      titleHeight: other._titleHeight,
      itemHeight: other._itemHeight,
      itemTextStyle: itemTextStyle.merge(other._itemTextStyle),
      itemTextSelectedStyle:
          itemTextSelectedStyle.merge(other._itemTextSelectedStyle),
      dividerColor: other._dividerColor,
      cornerRadius: other._cornerRadius,
    );
  }
}
