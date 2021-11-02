import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:get/get.dart';

import 'controller.dart';
import 'photo/component.dart';

class PhotosTabPage extends StatelessWidget {
  final controller = Get.put(PhotosTabController());

  PhotosTabPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabs = List.generate(10, (index) {
      final width =
          (screenWidthDp * screenDevicePixelRatio * index * 0.1).round();
      return "https://picsum.photos/$width/$width";
    });
    return BaseTabPage(
      tabBarHeight: 44,
      isScrollable: true,
      tabs: tabs.map(
        (e) {
          return Text(e.split("/").last);
        },
      ).toList(),
      children: tabs.map(
        (url) {
          return PhotoComponent(url: url);
        },
      ).toList(),
    );
  }
}
