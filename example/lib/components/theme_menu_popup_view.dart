import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

const List<ThemeMode> _themeModes = [
  ThemeMode.system,
  ThemeMode.light,
  ThemeMode.dark,
];

class ThemeMenuPopupView extends StatelessWidget {
  const ThemeMenuPopupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(15.0),
          color: appTheme(context).scaffoldBackgroundColor,
          child: ObxValue<Rx<ThemeMode>>((mode) {
            return Column(
              children: [
                SizedBox(
                  height: screenStatusBarHeightDp,
                ),
                Text(
                  "${mode.value}",
                  style: appTheme(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: appTheme(context).primaryColor),
                ),
                const SizedBox(height: 15),
                Column(
                  children: _themeModes.map((e) {
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
        Expanded(
          child: GestureDetector(
            onTap: () {
              offBack();
            },
            child: Container(
              color: Colors.black54,
            ),
          ),
        )
      ],
    );
  }
}
