import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

void showChangeColorDialog(BuildContext context, Color color,
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
      );
    },
  );
}

void showChangeThemeDialog(BuildContext context) {
  const List<ThemeMode> themeModes = [
    ThemeMode.system,
    ThemeMode.light,
    ThemeMode.dark,
  ];
  showBaseDialog<bool>(
    context: context,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            BaseCustomAlertDialog(
              borderRadius: BorderRadius.zero,
              margin: EdgeInsets.zero,
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ObxValue<Rx<ThemeMode>>((mode) {
                  return Column(
                    children: [
                      Text(
                        "${mode.value}",
                        style: appTheme(context)
                            .textTheme
                            .headline5!
                            .copyWith(color: appTheme(context).primaryColor),
                      ),
                      Column(
                        children: themeModes.map((e) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: BaseBackgroundButton(
                                title: Text("$e"),
                                onPressed: () {
                                  showLoading();
                                  mode.value = e;
                                  Get.changeThemeMode(mode.value);
                                  showSuccessToast("$mode");
                                  offBack();
                                }),
                          );
                        }).toList(),
                      )
                    ],
                  );
                }, ThemeMode.system.obs),
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
