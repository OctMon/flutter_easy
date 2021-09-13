import 'dart:ui';

import 'package:get/get.dart';

/// ui.window.locale
final Locale? appDeviceLocale = Get.deviceLocale;

/// The app Current locale
Locale? get appLocale => Get.locale;

void appUpdateLocale(Locale l) {
  Get.updateLocale(l);
}
