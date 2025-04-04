import 'dart:ui';

import 'package:flutter_easy/flutter_easy.dart';

List<Locale> _supportedLocales = [];

class IntlUtil {
  static void initSupportedLocales(List<Locale> supportedLocales) {
    _supportedLocales = supportedLocales;
  }
}

bool get currentLocalIsZH => BaseIntl.getCurrentLocale().startsWith("zh");

extension AssetExtensions on String {
  String get translationAsset {
    var key = BaseIntl.getCurrentLocale().split("_").first;
    if (key.isNotEmpty) {
      if (key == _supportedLocales.first.languageCode) {
        return this;
      }
      final name = getBasename(this);
      final replace = replaceAll(name, getJoin(key, name));
      logDebug(replace);
      return replace;
    }
    return this;
  }
}
