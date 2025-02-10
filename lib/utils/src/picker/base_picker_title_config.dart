import 'package:flutter/material.dart';

class BasePickerTitleConfig {
  /// DateTimePicker theme.
  ///
  /// [cancel] Custom cancel widget.
  /// [confirm] Custom confirm widget.
  /// [title] Custom title widget. If specify a title widget, the cancel and confirm widgets will not display. Must set [titleHeight] value for custom title widget.
  /// [showTitle] Whether display title widget or not. If set false, the default cancel and confirm widgets will not display, but the custom title widget will display if had specified one custom title widget.
  /// [titleContent] Title content
  const BasePickerTitleConfig({
    this.cancel,
    this.cancelTitle,
    this.confirm,
    this.confirmTitle,
    this.title,
    this.showTitle = false,
    this.titleContent,
  });

  static const BasePickerTitleConfig config = BasePickerTitleConfig();

  /// Custom cancel [Widget].
  final Widget? cancel;

  final String? cancelTitle;

  /// Custom confirm [Widget].
  final Widget? confirm;

  final String? confirmTitle;

  /// Custom title [Widget]. If specify a title widget, the cancel and confirm widgets will not display.
  final Widget? title;

  /// Whether display title widget or not. If set false, the default cancel and confirm widgets will not display, but the custom title widget will display if had specified one custom title widget.
  final bool showTitle;

  final String? titleContent;

  BasePickerTitleConfig copyWith({
    Widget? cancel,
    Widget? confirm,
    Widget? title,
    bool? showTitle,
    String? titleContent,
  }) {
    return BasePickerTitleConfig(
      cancel: cancel ?? this.cancel,
      confirm: confirm ?? this.confirm,
      title: title ?? this.title,
      showTitle: showTitle ?? this.showTitle,
      titleContent: titleContent ?? this.titleContent,
    );
  }
}
