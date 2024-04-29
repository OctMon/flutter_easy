import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_easy/flutter_easy.dart';

typedef BaseConnectivityResult = ConnectivityResult;

Stream<List<BaseConnectivityResult>> onConnectivityChanged() {
  final Connectivity _connectivity = Connectivity();
  return _connectivity.onConnectivityChanged;
}

Future<List<BaseConnectivityResult>> checkConnectivity() async {
  final Connectivity _connectivity = Connectivity();
  return _connectivity.checkConnectivity();
}

extension BaseConnectivityResultExt on List<BaseConnectivityResult> {
  bool get hasInternetAccess {
    if (contains(BaseConnectivityResult.mobile)) {
      logDebug('成功连接移动网络');
      return true;
    } else if (contains(BaseConnectivityResult.wifi)) {
      logDebug('成功连接WIFI');
      return true;
    } else if (contains(BaseConnectivityResult.ethernet)) {
      logDebug('成功连接到以太网');
      return true;
    } else if (contains(BaseConnectivityResult.vpn)) {
      logDebug('成功连接vpn网络');
      return true;
    } else if (contains(BaseConnectivityResult.bluetooth)) {
      logDebug('成功连接蓝牙');
      return true;
    } else if (contains(BaseConnectivityResult.other)) {
      logDebug('成功连接除以上以外的网络');
      return true;
    } else if (contains(BaseConnectivityResult.none)) {
      logDebug('没有连接到任何网络');
      return false;
    } else {
      logDebug('其它网络情况');
      return true;
    }
  }
}
