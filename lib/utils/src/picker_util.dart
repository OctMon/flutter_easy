import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easy/components/src/base.dart';
import 'package:flutter_easy/flutter_easy.dart';

Future<DateTime?> showModalPopupDatePicker(BuildContext context,
    {double? height,
    CupertinoDatePickerMode mode = CupertinoDatePickerMode.dateAndTime,
    DateTime? initialDateTime,
    DateTime? minimumDate,
    DateTime? maximumDate,
    int? minimumYear,
    int? maximumYear}) {
  return showCupertinoModalPopup(
    context: context,
    builder: (context) {
      DateTime dateTime = initialDateTime ?? DateTime.now();
      return Container(
        height: height ?? 260,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  BaseButton(
                    onPressed: () {
                      Navigator.of(context).pop(null);
                    },
                    child: BaseText(
                      '取消',
                    ),
                  ),
                  BaseButton(
                    onPressed: () {
                      Navigator.of(context).pop(dateTime);
                    },
                    child: BaseText(
                      '确认',
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: (height ?? 260) - 60,
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
      );
    },
  );
}

Future<int?> showModalPopupTitlesPicker(
  BuildContext context,
  List<String> titles, {
  double? height,
}) {
  return showCupertinoModalPopup(
    context: context,
    builder: (context) {
      int index = 0;
      return Container(
        height: height ?? 260,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  BaseButton(
                    onPressed: () {
                      Navigator.of(context).pop(null);
                    },
                    child: BaseText(
                      '取消',
                      style: TextStyle(
                        color: colorWithTint,
                      ),
                    ),
                  ),
                  BaseButton(
                    onPressed: () {
                      Navigator.of(context).pop(index);
                    },
                    child: BaseText(
                      '确认',
                      style: TextStyle(
                        color: colorWithTint,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: (height ?? 260) - 60,
              child: CupertinoPicker(
                backgroundColor: Colors.white,
                itemExtent: 36, //item的高度
                onSelectedItemChanged: (changed) {
                  index = changed;
                },
                children: titles.map((text) => BaseText(text)).toList(),
              ),
            ),
          ],
        ),
      );
    },
  );
}
