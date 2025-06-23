import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

class BaseTabStateController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  List<BaseKeyValue> tabs = [];

  @override
  void onInit() {
    tabController = TabController(
      length: tabs.length,
      vsync: this,
      initialIndex: Get.arguments?["index"] ?? 0,
    );
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
