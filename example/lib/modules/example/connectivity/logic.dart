import 'dart:async';

import 'package:flutter_easy/flutter_easy.dart';

class ConnectivityLogic extends GetxController {
  /// 消息订阅
  StreamSubscription? _subscription;

  final connectionStatus = BaseConnectivityResult.none.obs;
  final hasInternetAccess = false.obs;

  @override
  void onInit() {
    // checkConnectivity().then(_updateConnectionStatus);
    _subscription = onConnectivityChanged().listen(_updateConnectionStatus);
    super.onInit();
  }

  Future<void> _updateConnectionStatus(BaseConnectivityResult result) async {
    connectionStatus.value = result;
    hasInternetAccess.value = result.hasInternetAccess;
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
