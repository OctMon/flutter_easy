import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/components/theme_menu_popup_view.dart';

void showChangeColorDialog(BuildContext context, Color color,
    {required ValueChanged<Color> completion}) {
  showBaseAlert<bool>(
    PopScope(
      onPopInvokedWithResult: (bool didPop, _) {
        if (!didPop) {
          offBack();
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          BaseCustomAlertDialog(
            margin: const EdgeInsets.symmetric(horizontal: 38),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ObxValue<Rx<Color>>((color) {
                return Column(
                  children: [
                    FlutterLogo(
                      size: 200.w,
                      style: FlutterLogoStyle.horizontal,
                      textColor: color.value,
                    ),
                    BaseButton(
                        child: Icon(
                          Icons.access_time_filled,
                          color: color.value,
                        ),
                        onPressed: () {
                          showLoading();
                          1.seconds.delay(() {
                            dismissLoading();
                            color.value = colorWithRandom();
                            completion(color.value);
                          });
                        })
                  ],
                );
              }, color.obs),
            ),
          ),
          // const SizedBox(height: 15),
          BaseButton(
            child: const Icon(
              Icons.power_settings_new_outlined,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              offBack();
            },
          ),
        ],
      ),
    ),
  );
}

void showChangeThemeDialog(BuildContext context) {
  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return const ThemeMenuPopupView();
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    ),
  );
}
