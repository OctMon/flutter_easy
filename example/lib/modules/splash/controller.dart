import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/routes.dart';

class SplashController extends GetxController {
  /// 闪屏页倒计时
  var countDown = (-1).obs;

  /// 计时器⌛️
  TimerUtil? timer;

  @override
  void onReady() {
    // if (isProduction) {
      _startCountdownTimer();
    // } else {
    //   toRoot();
    // }

    super.onReady();
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  void _startCountdownTimer() {
    int count = randomInt(3) + 1;

    timer = TimerUtil(
        totalTime: count * Duration.millisecondsPerSecond,
        callback: (current) {
          logDebug(current);
          countDown.value = current ~/ Duration.millisecondsPerSecond;

          if (countDown.value == 0) {
            toRoot();
          }
        });
    2.seconds.delay(() {
      timer?.run();
    });
  }

  void toRoot() {
    // 跳转 Root
    offNamed(Routes.root);
  }
}
