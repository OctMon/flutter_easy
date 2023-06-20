import 'dart:async';

import 'package:flutter/foundation.dart';

/// 事件目标操作
/// void increase() {
///   count += 1;
/// }
extension FunctionExtensions on Function {
  /// 节流
  /// () async{
  ///   await Future.delayed(Duration(seconds: 1));
  ///   increase();
  /// }.throttle()
  VoidCallback throttle() {
    return FunctionProxy(this).throttle;
  }

  /// 指定时间节流
  /// increase.throttleWithTimeout(2000)
  VoidCallback throttleWithTimeout({int? timeout}) {
    return FunctionProxy(this, timeout: timeout).throttleWithTimeout;
  }

  ///防抖
  /// increase.debounce(timeout: 1000)
  VoidCallback debounce({int? timeout}) {
    return FunctionProxy(this, timeout: timeout).debounce;
  }
}

class FunctionProxy {
  static final Map<String, bool> _funcThrottle = {};
  static final Map<String, Timer> _funcDebounce = {};
  final Function? target;

  final int timeout;

  FunctionProxy(this.target, {int? timeout}) : timeout = timeout ?? 500;

  void throttle() async {
    String key = hashCode.toString();
    bool enable = _funcThrottle[key] ?? true;
    if (enable) {
      _funcThrottle[key] = false;
      try {
        await target?.call();
      } catch (e) {
        rethrow;
      } finally {
        _funcThrottle.remove(key);
      }
    }
  }

  void throttleWithTimeout() {
    String key = hashCode.toString();
    bool enable = _funcThrottle[key] ?? true;
    if (enable) {
      _funcThrottle[key] = false;
      Timer(Duration(milliseconds: timeout), () {
        _funcThrottle.remove(key);
      });
      target?.call();
    }
  }

  void debounce() {
    String key = hashCode.toString();
    Timer? timer = _funcDebounce[key];
    timer?.cancel();
    timer = Timer(Duration(milliseconds: timeout), () {
      Timer? t = _funcDebounce.remove(key);
      t?.cancel();
      target?.call();
    });
    _funcDebounce[key] = timer;
  }
}
