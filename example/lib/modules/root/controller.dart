import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/utils/check_privacy.dart';

class RootController extends BaseLifeCycleController {
  /// 当前下标
  var currentIndex = 0.obs;

  @override
  void onReady() {
    checkPrivacy();
    super.onReady();
  }

  @override
  void onDetached() {
    logDebug("onDetached");
  }

  @override
  void onInactive() {
    logDebug("onInactive");
  }

  @override
  void onPaused() {
    logDebug("onPaused");
  }

  @override
  void onResumed() {
    logDebug("onResumed");
  }
}
