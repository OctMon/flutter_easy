import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/utils/check_privacy.dart';

class RootController extends GetxController {
  /// 当前下标
  var currentIndex = 0.obs;

  @override
  void onReady() {
    if (Get.context != null) {
      checkPrivacy(Get.context!);
    }
    super.onReady();
  }
}
