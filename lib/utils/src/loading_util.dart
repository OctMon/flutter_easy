import 'package:flutter/material.dart';
import 'package:flutter_easy/components/src/base_animation_image.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

VoidCallback? baseDefaultShowLoadingHandler;
VoidCallback? baseDefaultDismissLoadingHandler;

void showLoading({
  String? status,
  Widget? indicator,
  EasyLoadingMaskType? maskType,
  bool? dismissOnTap,
}) {
  if (baseDefaultShowLoadingHandler != null) {
    baseDefaultShowLoadingHandler?.call();
  } else {
    EasyLoading.show(
        status: status,
        indicator: indicator ?? baseDefaultAnimationImage,
        maskType: maskType,
        dismissOnTap: dismissOnTap);
  }
}

void showProgress(
  double value, {
  String? status,
  EasyLoadingMaskType? maskType,
}) {
  EasyLoading.showProgress(
    value,
    status: status,
    maskType: maskType,
  );
}

void dismissLoading() {
  if (baseDefaultDismissLoadingHandler != null) {
    baseDefaultDismissLoadingHandler?.call();
  } else {
    EasyLoading.dismiss();
  }
}
