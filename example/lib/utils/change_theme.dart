import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

void showChangeThemeDialog(BuildContext context, Color color,
    {required ValueChanged<Color> completion}) {
  showBaseDialog<bool>(
    context: context,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async {
          return false;
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
                        size: 200.adaptRatio,
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
                }, colorWithDarkSecondary.obs),
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
      );
    },
  );
}
