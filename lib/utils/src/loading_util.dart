import 'package:flutter/material.dart';
import 'package:flutter_easy/components/src/base_animation_image.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void showLoading({
  String? status,
  Widget? indicator,
  EasyLoadingMaskType? maskType,
  bool? dismissOnTap,
}) {
  EasyLoading.show(
      status: status,
      indicator: indicator ?? baseDefaultAnimationImage,
      maskType: (maskType == null &&
              EasyLoading.instance.maskType == EasyLoadingMaskType.none)
          ? EasyLoadingMaskType.clear
          : EasyLoading.instance.maskType,
      dismissOnTap: dismissOnTap);
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
  EasyLoading.dismiss();
}
