import 'package:flutter_easyloading/flutter_easyloading.dart';

void showToast(
  String status, {
  Duration? duration,
  EasyLoadingToastPosition? toastPosition,
  EasyLoadingMaskType? maskType,
  bool? dismissOnTap,
}) {
  EasyLoading.showToast(
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
  EasyLoadingMaskType? maskType,
  bool? dismissOnTap,
}) {
  EasyLoading.showSuccess(
    status,
    duration: duration,
    maskType: maskType,
    dismissOnTap: dismissOnTap,
  );
}

void showErrorToast(
  String status, {
  Duration? duration,
  EasyLoadingMaskType? maskType,
  bool? dismissOnTap,
}) {
  EasyLoading.showError(
    status,
    duration: duration,
    maskType: maskType,
    dismissOnTap: dismissOnTap,
  );
}

void showInfoToast(
  String status, {
  Duration? duration,
  EasyLoadingMaskType? maskType,
  bool? dismissOnTap,
}) {
  EasyLoading.showInfo(
    status,
    duration: duration,
    maskType: maskType,
    dismissOnTap: dismissOnTap,
  );
}
