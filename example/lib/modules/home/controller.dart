import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

import 'state.dart';

class HomeController extends GetxController with SingleGetTickerProviderMixin {
  final state = HomeState();

  @override
  void onInit() {
    state.animationController = AnimationController(
        vsync: this /*NavigatorState()*/,
        duration: Duration(milliseconds: 2000));
    super.onInit();
  }

  @override
  void onReady() {
    state.animationController.repeat(reverse: true);
    super.onReady();
  }

  @override
  void onClose() {
    // state.animationController.dispose();
    super.onClose();
  }
}
