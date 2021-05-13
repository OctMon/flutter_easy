import 'package:flutter/material.dart';
import 'package:flutter_easy/components/export.dart';

bool _loadingStatus = false;

void showLoading(BuildContext context, {String? message}) {
  // 已有弹窗，则不再显示弹窗
  if (_loadingStatus) {
    return;
  }
  _loadingStatus = true;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: baseDefaultAnimationImage != null ? Colors.transparent : Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: (baseDefaultAnimationImage != null && message == null)
                ? baseDefaultAnimationImage
                : BaseLoadingView(message: message),
          ),
        ),
      );
    },
  );
}

void dismissLoading(BuildContext context) {
  if (_loadingStatus) {
    _loadingStatus = false;
    Navigator.of(context, rootNavigator: true).pop();
  }
}
