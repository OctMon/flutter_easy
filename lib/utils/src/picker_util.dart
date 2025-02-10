import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../flutter_easy.dart';

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
                    child: Text(
                      kBaseMultiDataPickerCancelTitle,
                    ),
                  ),
                  BaseButton(
                    onPressed: () {
                      Navigator.of(context).pop(dateTime);
                    },
                    child: Text(
                      kBaseMultiDataPickerConfirmTitle,
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
