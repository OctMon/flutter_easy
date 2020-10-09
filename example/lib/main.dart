import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy/flutter_easy.dart';

import 'app.dart';

void main() {
  createEasyApp(
    isSelectBaseURLTypeFlag: true,
    initCallback: initApp,
    completionCallback: () {
      runApp(createApp());
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
