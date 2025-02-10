import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

import 'base_picker_title_config.dart';
import 'base_multi_data_picker.dart';

/// DatePicker's title widget.
class BasePickerTitle extends StatelessWidget {
  final BasePickerTitleConfig pickerTitleConfig;
  final VoidCallback onCancel, onConfirm;

  const BasePickerTitle({
    super.key,
    required this.onCancel,
    required this.onConfirm,
    this.pickerTitleConfig = BasePickerTitleConfig.config,
  });

  @override
  Widget build(BuildContext context) {
    if (pickerTitleConfig.title != null) {
      return pickerTitleConfig.title!;
    }
    return Container(
      height: pickerTitleHeight,
      decoration: const ShapeDecoration(
        color: pickerBackgroundColor,
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
                  pickerTitleConfig.titleContent ?? "",
                  // style: themeData!.titleTextStyle.generateTextStyle(),
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
    Widget? cancelWidget = pickerTitleConfig.cancel;
    cancelWidget ??= Text(
      pickerTitleConfig.cancelTitle ?? "",
      style: const TextStyle(
        fontSize: 16,
        color: colorWithHex3,
      ),
      textAlign: TextAlign.left,
    );
    return cancelWidget;
  }

  /// render confirm button widget
  Widget _renderConfirmWidget(BuildContext context) {
    Widget? confirmWidget = pickerTitleConfig.confirm;
    confirmWidget ??= Text(
      pickerTitleConfig.confirmTitle ?? "",
      style: TextStyle(
        fontSize: 16,
        color: appTheme(context).primaryColor,
      ),
      textAlign: TextAlign.right,
    );
    return confirmWidget;
  }
}
