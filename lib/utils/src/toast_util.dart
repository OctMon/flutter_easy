import 'package:flutter/material.dart';

import '../../components/src/base.dart';
import 'vendor_util.dart';

void showToast(
  String status, {
  Duration? duration,
  BaseEasyLoadingToastPosition? toastPosition,
  BaseEasyLoadingMaskType? maskType,
  bool? dismissOnTap,
}) {
  BaseEasyLoading.showToast(
    status,
    duration: duration,
    toastPosition: toastPosition,
    maskType: maskType,
    dismissOnTap: dismissOnTap,
  );
}

void showSuccessToast(
  String status, {
  Duration? duration,
  BaseEasyLoadingMaskType? maskType,
  bool? dismissOnTap,
}) {
  BaseEasyLoading.showSuccess(
    status,
    duration: duration,
    maskType: maskType,
    dismissOnTap: dismissOnTap,
  );
}

void showErrorToast(
  String status, {
  Duration? duration,
  BaseEasyLoadingMaskType? maskType,
  bool? dismissOnTap,
}) {
  BaseEasyLoading.showError(
    status,
    duration: duration,
    maskType: maskType,
    dismissOnTap: dismissOnTap,
  );
}

void showInfoToast(
  String status, {
  Duration? duration,
  BaseEasyLoadingMaskType? maskType,
  bool? dismissOnTap,
}) {
  BaseEasyLoading.showInfo(
    status,
    duration: duration,
    maskType: maskType,
    dismissOnTap: dismissOnTap,
  );
}

Color? kNotificationToastBackgroundColor;
Duration? kNotificationToastDuration = Duration(seconds: 2);
TextStyle? kNotificationToastTitleStyle;
var kNotificationToastBorderRadius =
    const BorderRadius.all(Radius.circular(10.0));

void showNotificationTextToast(String title,
    {Duration? duration, Alignment? align}) {
  showNotificationCustomToast(
    Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: BaseCard(
        child: Row(
          children: [
            Text(
              title,
              style: kNotificationToastTitleStyle,
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        borderRadius: kNotificationToastBorderRadius,
        color: kNotificationToastBackgroundColor,
      ),
    ),
    duration: duration,
    align: align,
  );
}

void showNotificationCustomToast(Widget widget,
    {Duration? duration, Alignment? align}) {
  BaseBotToast.showCustomNotification(
    align: align ?? Alignment.topCenter,
    duration: duration ?? kNotificationToastDuration,
    toastBuilder: (void Function() cancelFunc) {
      return widget;
    },
  );
}
