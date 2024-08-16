import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

import 'state.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final state = HomeState();

  var color = setLightPrimaryColor.obs;

  final RxList<BaseKeyValue> pathList = <BaseKeyValue>[].obs;

  @override
  void onClose() {
    state.animationController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    state.animationController = AnimationController(
        vsync: this /*NavigatorState()*/,
        duration: const Duration(milliseconds: 2000));
    onGetList();
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

  Future<void> onGetList() async {
    final functions = [
      "getAppTemporaryDirectory()",
      "getAppDocumentsDirectory()",
      if (isIOS) "getAppLibraryDirectory()",
      "getAppSupportDirectory()",
      if (isAndroid) "getAppExternalStorageDirectory()",
    ];
    final list = await Future.wait([
      getAppTemporaryDirectory(),
      getAppDocumentsDirectory(),
      if (isIOS) getAppLibraryDirectory(),
      getAppSupportDirectory(),
      if (isAndroid) getAppExternalStorageDirectory(),
    ]);
    pathList.value = List.generate(
        list.length,
        (index) =>
            BaseKeyValue(key: functions[index], value: "${list[index]?.path}"));
  }
}
