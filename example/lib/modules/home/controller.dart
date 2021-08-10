import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'state.dart';

class HomeController extends GetxController with SingleGetTickerProviderMixin {
  final state = HomeState();

  @override
  void onInit() {
    state.animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    Future.delayed(
        Duration.zero, () => state.animationController.repeat(reverse: true));
    super.onInit();
  }

  @override
  void onClose() {
    state.animationController.dispose();
    super.onClose();
  }
}
