// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:shared_preferences_web/shared_preferences_web.dart';

String get webUserAgent => window.navigator.userAgent;

dynamic sharedPreferencesInstance() => SharedPreferencesPlugin();
