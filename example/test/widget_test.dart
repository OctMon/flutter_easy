// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Verify Platform version', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(createEasyApp(
      // TODO:运行非web报错的时候注掉即可
      // sharedPreferencesWebInstance: SharedPreferencesPlugin(),
      // webUserAgent: html.window.navigator.userAgent.toLowerCase(),
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
    ));

    // Verify that platform version is retrieved.
    expect(
      find.byWidgetPredicate(
        (Widget widget) => widget is Text &&
                           widget.data.startsWith('Running on:'),
      ),
      findsOneWidget,
    );
  });
}
