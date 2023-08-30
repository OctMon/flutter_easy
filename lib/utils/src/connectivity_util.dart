import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy/flutter_easy.dart';

/// Connection status check result.
enum BaseConnectivityResult {
  /// Mobile: Device connected to cellular network
  mobile,

  /// Other: Device is connected to network
  other,

  /// None: Device not connected to any network
  none,
  unknown,
}

final Connectivity _connectivity = Connectivity();

/// 消息订阅
/// StreamSubscription? _subscription;

/// final result = BaseConnectivityResult.unknown.obs;

/// @override
/// void onInit() {
/// // checkConnectivity().then((value) => result.value = value);
/// onConnectivityChangedListen((result) {
/// this.result.value = result;
/// }).then((value) => _subscription = value);
/// super.onInit();
/// }

/// @override
/// void onClose() {
/// _subscription?.cancel();
/// super.onClose();
/// }
///
Future<StreamSubscription<ConnectivityResult>?> onConnectivityChangedListen(
    ValueChanged<BaseConnectivityResult> changed) async {
  try {
    return _connectivity.onConnectivityChanged.listen((result) {
      changed(_updateConnectionStatus(result));
    });
  } on PlatformException catch (e) {
    logDebug(e);
  }
  return null;
}

Future<BaseConnectivityResult> checkConnectivity() async {
  final result = await _connectivity.checkConnectivity();
  return _updateConnectionStatus(result);
}

BaseConnectivityResult _updateConnectionStatus(ConnectivityResult result) {
  if (result == ConnectivityResult.mobile) {
    logDebug('成功连接移动网络');
    return BaseConnectivityResult.mobile;
  } else if (result == ConnectivityResult.wifi) {
    logDebug('成功连接WIFI');
    return BaseConnectivityResult.other;
  } else if (result == ConnectivityResult.ethernet) {
    logDebug('成功连接到以太网');
    return BaseConnectivityResult.other;
  } else if (result == ConnectivityResult.vpn) {
    logDebug('成功连接vpn网络');
    return BaseConnectivityResult.other;
  } else if (result == ConnectivityResult.bluetooth) {
    logDebug('成功连接蓝牙');
    return BaseConnectivityResult.other;
  } else if (result == ConnectivityResult.other) {
    logDebug('成功连接除以上以外的网络');
    return BaseConnectivityResult.other;
  } else if (result == ConnectivityResult.none) {
    logDebug('没有连接到任何网络');
    return BaseConnectivityResult.none;
  }
  return BaseConnectivityResult.unknown;
}
