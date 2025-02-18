import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/api/api.dart';

import 'app.dart';

void main() async {
  await initEasyApp(
    appBaseURLChangedCallback: () {
      // Reload API
      configAPI(null);
    },
    logFileWrapSplitter: " ",
    customExceptionReport: (error, stack) {},
  );
  await initApp();
  if (isWeb && !isWebInMobile) {
    runApp(
      DevicePreview(
        // enabled: !kReleaseMode,
        builder: (context) => MyApp(), // Wrap your app
      ),
    );
  } else {
    runApp(const MyApp());
  }
  if (isAndroid) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // Set overlay style status bar. It must run after MyApp(), because MaterialApp may override it.
    SystemUiOverlayStyle systemUiOverlayStyle =
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}
