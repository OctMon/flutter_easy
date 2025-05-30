import 'package:flutter/material.dart';

class BasePickerTitleConfig {
  const BasePickerTitleConfig({
    this.cancel,
    this.cancelLocalized = "Cancel",
    this.confirm,
    this.confirmLocalized = "Confirm",
    this.title,
    this.titleLocalized = "",
    this.showTitle = false,
    this.titleContent,
  });

  static BasePickerTitleConfig defaultConfig = const BasePickerTitleConfig();

  /// Custom cancel [Widget].
  final Widget? cancel;

  final String cancelLocalized;

  /// Custom confirm [Widget].
  final Widget? confirm;

  final String confirmLocalized;

  /// Custom title [Widget]. If specify a title widget, the cancel and confirm widgets will not display.
  final Widget? title;

  final String titleLocalized;

  /// Whether display title widget or not. If set false, the default cancel and confirm widgets will not display, but the custom title widget will display if had specified one custom title widget.
  final bool showTitle;

  final String? titleContent;

  BasePickerTitleConfig copyWith({
    Widget? cancel,
    String? cancelLocalized,
    Widget? confirm,
    String? confirmLocalized,
    Widget? title,
    String? titleLocalized,
    bool? showTitle,
    String? titleContent,
  }) {
    return BasePickerTitleConfig(
      cancel: cancel ?? this.cancel,
      cancelLocalized: cancelLocalized ?? this.cancelLocalized,
      confirm: confirm ?? this.confirm,
      confirmLocalized: confirmLocalized ?? this.confirmLocalized,
      title: title ?? this.title,
      titleLocalized: titleLocalized ?? this.titleLocalized,
      showTitle: showTitle ?? this.showTitle,
      titleContent: titleContent ?? this.titleContent,
    );
  }
}
