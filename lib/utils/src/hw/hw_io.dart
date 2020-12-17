import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_windows/shared_preferences_windows.dart';

import 'package:flutter_easy/flutter_easy.dart';

String get webUserAgent => "";

String get webOrigin => "";

dynamic sharedPreferencesInstance() {
  if (isWindows) {
    return SharedPreferencesWindows.instance;
  } else {
    return SharedPreferences.getInstance();
  }
}
