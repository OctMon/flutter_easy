import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

import 'logic.dart';

class ConnectivityPage extends StatelessWidget {
  ConnectivityPage({super.key});

  final logic = Get.put(ConnectivityLogic());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("connectionStatus: ${logic.connectionStatus}}"),
                Text("hasInternetAccess: ${logic.hasInternetAccess.value}}"),
              ],
            );
          }),
          const SizedBox(height: 30),
          const Text(
            "中文字体 Thin = w100",
            style: TextStyle(
              fontSize: 22,
              fontWeight: fontWeightThin,
            ),
          ),
          const Text(
            "中文字体 ExtraLight = w200",
            style: TextStyle(
              fontSize: 22,
              fontWeight: fontWeightExtraLight,
            ),
          ),
          const Text(
            "中文字体 Light = w300",
            style: TextStyle(
              fontSize: 22,
              fontWeight: fontWeightLight,
            ),
          ),
          const Text(
            "中文字体 Regular = w400",
            style: TextStyle(
              fontSize: 22,
              fontWeight: fontWeightRegular,
            ),
          ),
          const Text(
            "中文字体 Medium = w500",
            style: TextStyle(
              fontSize: 22,
              fontWeight: fontWeightMedium,
            ),
          ),
          const Text(
            "中文字体 Semi-bold = w600",
            style: TextStyle(
              fontSize: 22,
              fontWeight: fontWeightSemiBold,
            ),
          ),
          const Text(
            "中文字体 Bold = w700",
            style: TextStyle(
              fontSize: 22,
              fontWeight: fontWeightBold,
            ),
          ),
          const Text(
            "中文字体 Extra-bold = w800",
            style: TextStyle(
              fontSize: 22,
              fontWeight: fontWeightBlack,
            ),
          ),
          const Text(
            "中文字体 Black = w900",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
