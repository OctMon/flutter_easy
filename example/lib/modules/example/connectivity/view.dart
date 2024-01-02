import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

import 'logic.dart';

class ConnectivityPage extends StatelessWidget {
  ConnectivityPage({Key? key}) : super(key: key);

  final logic = Get.put(ConnectivityLogic());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          Obx(() {
            return Text("${logic.result.value}");
          }),
          SizedBox(height: 30),
          Text(
            "中文字体 Thin = w100",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: fontWeightThin,
            ),
          ),
          Text(
            "中文字体 ExtraLight = w200",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: fontWeightExtraLight,
            ),
          ),
          Text(
            "中文字体 Light = w300",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: fontWeightLight,
            ),
          ),
          Text(
            "中文字体 Regular = w400",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: fontWeightRegular,
            ),
          ),
          Text(
            "中文字体 Medium = w500",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: fontWeightMedium,
            ),
          ),
          Text(
            "中文字体 Semi-bold = w600",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: fontWeightSemiBold,
            ),
          ),
          Text(
            "中文字体 Bold = w700",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: fontWeightBold,
            ),
          ),
          Text(
            "中文字体 Extra-bold = w800",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: fontWeightBlack,
            ),
          ),
          Text(
            "中文字体 Black = w900",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
