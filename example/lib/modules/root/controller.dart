import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/api/http_bin/http_bin_api.dart';
import 'package:get/get.dart' hide GetNumUtils, GetDurationUtils;

class RootController extends GetxController {
  /// 当前下标
  var currentIndex = 0.obs;

  /// 闪屏页倒计时
  var countDown = (-1).obs;

  /// 计时器⌛️
  TimerUtil timer;

  @override
  void onReady() {
    _startCountdownTimer();
    _onRequest();
    super.onReady();
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  void _startCountdownTimer() {
    int count = randomInt(5) + 3;
    var callback = (current) {
      logWTF(current);
      countDown.value = current ~/ Duration.millisecondsPerSecond;
    };

    timer = TimerUtil(
        totalTime: count * Duration.millisecondsPerSecond, callback: callback);
    2.seconds.delay(() {
      timer?.run();
    });
  }

  Future<void> _onRequest() async {
    Result result = await getHttpBin(path: kApiHttpBinIp);
    if (result.response?.statusCode == 200) {
      showToast("${result.response}");
    }
  }
}
