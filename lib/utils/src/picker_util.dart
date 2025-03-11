import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../flutter_easy.dart';
import 'picker/base_multi_data_picker.dart';
import 'picker/base_picker_clip_r_rect.dart';
import 'picker/base_picker_title.dart';

Future<DateTime?> showModalPopupDatePicker(BuildContext context,
    {double? height,
    CupertinoDatePickerMode mode = CupertinoDatePickerMode.dateAndTime,
    DateTime? initialDateTime,
    DateTime? minimumDate,
    DateTime? maximumDate,
    int? minimumYear,
    int? maximumYear}) {
  DateTime dateTime = initialDateTime ?? DateTime.now();

  return showBaseBottomSheet(
    GestureDetector(
      child: SizedBox(
        height: pickerHeight + pickerTitleHeight,
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              BaseClickerClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
                child: BasePickerTitle(
                  onCancel: () {
                    Navigator.of(context).pop();
                  },
                  onConfirm: () {
                    Navigator.of(context).pop(dateTime);
                  },
                ),
              ),
              Container(
                height: pickerHeight,
                color: BasePickerTitleConfig.config.backgroundColor,
                child: CupertinoDatePicker(
                  mode: mode,
                  onDateTimeChanged: (changed) {
                    dateTime = changed;
                  },
                  initialDateTime: initialDateTime ?? DateTime.now(),
                  minimumDate: minimumDate,
                  maximumDate: maximumDate,
                  minimumYear: minimumYear ?? 1,
                  maximumYear: maximumYear,
                ),
              ),
            ],
          ),
        ),
      ),
      onVerticalDragUpdate: (v) => false,
    ),
    backgroundColor: Colors.transparent,
    isDismissible: true,
  );
}
