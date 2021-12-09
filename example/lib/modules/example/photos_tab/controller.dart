import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

class PhotosTabController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  final tabs = List.generate(10, (index) {
    final width =
        (screenWidthDp * screenDevicePixelRatio * index * 0.1).round();
    return "https://picsum.photos/$width/$width";
  });

  @override
  void onInit() {
    tabController = TabController(length: tabs.length, vsync: this);
    super.onInit();
  }
}
