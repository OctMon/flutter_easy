import 'package:flutter/material.dart';

import 'global_utils.dart';

import '../components/loading_view.dart';

bool _loadingStatus = false;

void showLoading({BuildContext context, String message}) {
  // 已有弹窗，则不再显示弹窗
  if (_loadingStatus) {
    return;
  }
  _loadingStatus = true;
  showDialog(
    context: context ?? GlobalUtils.context,
    barrierDismissible: false,
    builder: (context) {
      return Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: LoadingView(
              message: message,
            ),
          ),
        ),
      );
    },
  );
}

void dismissLoading({BuildContext context}) {
  if (_loadingStatus) {
    _loadingStatus = false;
    Navigator.of(context ?? GlobalUtils.context, rootNavigator: true).pop();
  }
}
