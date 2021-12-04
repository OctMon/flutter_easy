import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

import 'state.dart';

class HomeController extends GetxController with GetSingleTickerProviderStateMixin {
  final state = HomeState();

  var color = setLightPrimaryColor.obs;

  @override
  void onInit() {
    state.animationController = AnimationController(
        vsync: this /*NavigatorState()*/,
        duration: const Duration(milliseconds: 2000));
    super.onInit();
  }

  @override
  void onReady() {
    state.animationController.repeat(reverse: true);
    getClipboard().then((value) {
      if (value != null) {
        state.clipboard.value = value;
      }
    });
    super.onReady();
  }
}
