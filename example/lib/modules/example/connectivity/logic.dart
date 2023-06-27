import 'dart:async';

import 'package:flutter_easy/flutter_easy.dart';

class ConnectivityLogic extends GetxController {
  /// 消息订阅
  StreamSubscription? _subscription;

  final result = BaseConnectivityResult.unknown.obs;

  @override
  void onInit() {
    // checkConnectivity().then((value) => result.value = value);
    onConnectivityChangedListen((result) {
      this.result.value = result;
    }).then((value) => _subscription = value);
    super.onInit();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
