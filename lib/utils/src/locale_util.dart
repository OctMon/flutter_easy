import 'dart:ui';

/// 手动修改的locale
String? lastStorageLocale;

/// 手动修改的Locale
Locale? get lastLocale {
  if (lastStorageLocale != null) {
    Locale _locale = Locale(lastStorageLocale!);
    List<String> list = lastStorageLocale!.split("_");
    if (list.length > 1) {
      _locale = Locale(list.first, list.last);
    }
    return _locale;
  }
  return null;
}

late Future<void> Function(Locale?) onLocaleChange;
