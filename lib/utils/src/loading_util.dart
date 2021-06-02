import 'package:flutter/material.dart';
import 'package:flutter_easy/components/export.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void showLoading({
  String status,
  Widget indicator,
  EasyLoadingMaskType maskType,
  bool dismissOnTap,
}) {
  EasyLoading.show(
      status: status,
      indicator: indicator,
      maskType: maskType,
      dismissOnTap: dismissOnTap);
}

void showProgress(
  double value, {
  String status,
  EasyLoadingMaskType maskType,
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
