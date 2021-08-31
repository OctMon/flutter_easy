import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/api/api.dart';

import 'app.dart';

void main() {
  createEasyApp(
    initCallback: initApp,
    initView: initView,
    appBaseURLChangedCallback: () {
      // 刷新网络配置
      configAPI(null);
    },
    completionCallback: () {
      runApp(MyApp());
      if (isAndroid) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        // Set overlay style status bar. It must run after MyApp(), because MaterialApp may override it.
        SystemUiOverlayStyle systemUiOverlayStyle =
            SystemUiOverlayStyle(statusBarColor: Colors.transparent);
        SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
      }
    },
  );
}
