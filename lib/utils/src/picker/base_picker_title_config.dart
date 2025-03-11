import 'package:flutter/material.dart';

class BasePickerTitleConfig {
  /// DateTimePicker theme.
  ///
  /// [cancel] Custom cancel widget.
  /// [confirm] Custom confirm widget.
  /// [title] Custom title widget. If specify a title widget, the cancel and confirm widgets will not display. Must set [titleHeight] value for custom title widget.
  /// [showTitle] Whether display title widget or not. If set false, the default cancel and confirm widgets will not display, but the custom title widget will display if had specified one custom title widget.
  /// [titleBackgroundColor] Title background color
  /// [titleHeight] Title height
  /// [backgroundColor] Background color of picker
  const BasePickerTitleConfig({
    this.cancel,
    this.cancelTitle = "Cancel",
    this.confirm,
    this.confirmTitle = "Confirm",
    this.title,
    this.showTitle = false,
    this.titleContent,
    this.titleBackgroundColor = Colors.white,
    this.backgroundColor = Colors.white,
  });

  static BasePickerTitleConfig config = BasePickerTitleConfig();

  /// Custom cancel [Widget].
  final Widget? cancel;

  final String cancelTitle;

  /// Custom confirm [Widget].
  final Widget? confirm;

  final String confirmTitle;

  /// Custom title [Widget]. If specify a title widget, the cancel and confirm widgets will not display.
  final Widget? title;

  /// Whether display title widget or not. If set false, the default cancel and confirm widgets will not display, but the custom title widget will display if had specified one custom title widget.
  final bool showTitle;

  final String? titleContent;

  final Color titleBackgroundColor;

  final Color backgroundColor;

  BasePickerTitleConfig copyWith({
    Widget? cancel,
    String? cancelTitle,
    Widget? confirm,
    String? confirmTitle,
    Widget? title,
    bool? showTitle,
    String? titleContent,
    Color? titleBackgroundColor,
    Color? backgroundColor,
  }) {
    return BasePickerTitleConfig(
      cancel: cancel ?? this.cancel,
      cancelTitle: cancelTitle ?? this.cancelTitle,
      confirm: confirm ?? this.confirm,
      confirmTitle: confirmTitle ?? this.confirmTitle,
      title: title ?? this.title,
      showTitle: showTitle ?? this.showTitle,
      titleContent: titleContent ?? this.titleContent,
      titleBackgroundColor: titleBackgroundColor ?? this.titleBackgroundColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }
}
