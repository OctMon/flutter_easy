import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

import 'base_multi_data_picker.dart';

/// DatePicker's title widget.
class BasePickerTitle extends StatelessWidget {
  final BasePickerTitleConfig? pickerTitleConfig;
  final VoidCallback onCancel, onConfirm;

  const BasePickerTitle({
    super.key,
    required this.onCancel,
    required this.onConfirm,
    this.pickerTitleConfig,
  });

  BasePickerTitleConfig get config =>
      pickerTitleConfig ?? BasePickerTitleConfig.config;

  @override
  Widget build(BuildContext context) {
    final config = pickerTitleConfig ?? BasePickerTitleConfig.config;
    if (config.title != null) {
      return config.title!;
    }
    logDebug("BasePickerTitleConfig.config: ${BasePickerTitleConfig.config.titleBackgroundColor}");
    return Container(
      height: pickerTitleHeight,
      decoration: ShapeDecoration(
        color: config.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: pickerTitleHeight - 0.5,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: config.titleBackgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: pickerTitleHeight,
                    alignment: Alignment.center,
                    child: _renderCancelWidget(context),
                  ),
                  onTap: () {
                    onCancel();
                  },
                ),
                Text(
                  config.titleContent ?? "",
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: pickerTitleHeight,
                    alignment: Alignment.center,
                    child: _renderConfirmWidget(context),
                  ),
                  onTap: () {
                    onConfirm();
                  },
                ),
              ],
            ),
          ),
          const Divider(
            color: Color(0xFFF0F0F0),
            indent: 0.0,
            height: 0.5,
          ),
        ],
      ),
    );
  }

  /// render cancel button widget
  Widget _renderCancelWidget(BuildContext context) {
    Widget? cancelWidget = config.cancel;
    cancelWidget ??= Text(
      config.cancelTitle,
      style: const TextStyle(
        fontSize: 17,
        color: colorWithHex6,
      ),
      textAlign: TextAlign.left,
    );
    return cancelWidget;
  }

  /// render confirm button widget
  Widget _renderConfirmWidget(BuildContext context) {
    Widget? confirmWidget = config.confirm;
    confirmWidget ??= Text(
      config.confirmTitle,
      style: TextStyle(
        fontSize: 17,
        color: colorWithHex3,
      ),
      textAlign: TextAlign.right,
    );
    return confirmWidget;
  }
}
