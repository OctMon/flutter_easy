import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

import 'controller.dart';

class SplashPage extends StatelessWidget {
  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    String url =
        "https://picsum.photos/${(screenWidthDp * screenDevicePixelRatio).round()}/${(screenHeightDp * screenDevicePixelRatio).round()}";
    return Stack(
      children: [
        BaseLaunchRemote(
          keepLogo: false,
          url: url,
          onTap: () {
            showToast(url);
          },
        ),
        Align(
          alignment: Alignment.topRight,
          child: Obx(() {
            return BaseButton(
              padding: EdgeInsets.only(top: 35, right: 20),
              child: Text(controller.countDown.value == -1
                  ? ""
                  : '${controller.timer?.isActive}: skip(${controller.countDown})'),
              onPressed: () {
                controller.countDown.value = 0;
                controller.timer?.cancel();
                controller.toRoot();
              },
            );
          }),
        ),
      ],
    );
  }
}
