import 'package:flutter/material.dart';

import '../../../../configs/src/base_picker_config.dart';
import 'base_picker_title_config.dart';

/// DatePicker's title widget.
// ignore: must_be_immutable
class BasePickerTitle extends StatelessWidget {
  BasePickerTitleConfig? pickerTitleConfig;
  final VoidCallback onCancel, onConfirm;
  BasePickerConfig? themeData;

  BasePickerTitle({
    Key? key,
    required this.onCancel,
    required this.onConfirm,
    this.pickerTitleConfig,
    this.themeData,
  }) : super(key: key) {
    pickerTitleConfig ??= BasePickerTitleConfig.defaultConfig;
  }

  @override
  Widget build(BuildContext context) {
    if (pickerTitleConfig?.title != null) {
      return pickerTitleConfig!.title!;
    }
    return Container(
      height: themeData!.titleHeight,
      decoration: ShapeDecoration(
        color: themeData!.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(themeData!.cornerRadius),
            topRight: Radius.circular(themeData!.cornerRadius),
          ),
        ),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: themeData!.titleHeight - 0.5,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: themeData!.titleHeight,
                    alignment: Alignment.center,
                    child: _renderCancelWidget(context),
                  ),
                  onTap: () {
                    this.onCancel();
                  },
                ),
                Text(
                  pickerTitleConfig!.titleContent ?? "",
                  style: themeData!.titleTextStyle,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: themeData!.titleHeight,
                    alignment: Alignment.center,
                    child: _renderConfirmWidget(context),
                  ),
                  onTap: () {
                    this.onConfirm();
                  },
                ),
              ],
            ),
          ),
          Divider(
            color: themeData!.dividerColor,
            indent: 0.0,
            height: 0.5,
          ),
        ],
      ),
    );
  }

  /// render cancel button widget
  Widget _renderCancelWidget(BuildContext context) {
    Widget? cancelWidget = pickerTitleConfig!.cancel;
    if (cancelWidget == null) {
      TextStyle textStyle = themeData!.cancelTextStyle;
      cancelWidget = Text(
        pickerTitleConfig!.cancelLocalized,
        style: textStyle,
        textAlign: TextAlign.left,
      );
    }
    return cancelWidget;
  }

  /// render confirm button widget
  Widget _renderConfirmWidget(BuildContext context) {
    Widget? confirmWidget = pickerTitleConfig!.confirm;
    if (confirmWidget == null) {
      TextStyle textStyle = themeData!.confirmTextStyle;
      confirmWidget = Text(
        pickerTitleConfig!.confirmLocalized,
        style: textStyle,
        textAlign: TextAlign.right,
      );
    }
    return confirmWidget;
  }
}
