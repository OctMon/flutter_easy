import 'dart:async';

import 'package:flutter_easy/flutter_easy.dart';

class ConnectivityLogic extends GetxController {
  /// 消息订阅
  StreamSubscription<List<BaseConnectivityResult>>? _subscription;

  final connectionStatus = <BaseConnectivityResult>[].obs;
  final hasInternetAccess = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    _subscription = onConnectivityChanged().listen(
      _updateConnectionStatus,
      onError: _onError,
    );
    refreshStatus();
    super.onInit();
  }

  Future<void> refreshStatus() async {
    try {
      await _updateConnectionStatus(await checkConnectivity());
    } catch (error) {
      _onError(error);
    }
  }

  void _onError(Object error) {
    errorMessage.value = '无法读取网络状态，请重试';
    logError(error);
  }

  Future<void> _updateConnectionStatus(
      List<BaseConnectivityResult> result) async {
    if (isClosed) return;
    errorMessage.value = '';
    connectionStatus.value = result;
    hasInternetAccess.value = result.hasInternetAccess;
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
