import 'dart:async';

import 'package:flutter/foundation.dart';

class TimerUtil {
  TimerUtil(
      {this.periodic = Duration.millisecondsPerSecond,
      required this.totalTime,
      this.callback});

  /// 倒计时间隔 单位毫秒，默认1000毫秒
  int periodic;

  /// 倒计时总时间 单位毫秒
  int totalTime;

  /// 倒计时回调
  ValueChanged<int>? callback;

  Timer? timer;

  /// 倒计时是否启动.
  bool get isActive => timer?.isActive ?? false;

  /// 启动倒计时
  void run() {
    if (isActive || periodic <= 0 || totalTime <= 0) return;
    Duration duration = Duration(milliseconds: periodic);
    _runCallback(totalTime);
    timer = Timer.periodic(duration, (Timer timer) {
      totalTime -= periodic;
      if (totalTime >= periodic) {
        _runCallback(totalTime);
      } else if (totalTime == 0) {
        _runCallback(totalTime);
      } else {
        cancel();
      }
    });
  }

  void _runCallback(int time) {
    if (callback != null) {
      callback!(time);
    }
  }

  /// 重设倒计时总时间
  void repeat(int totalTime) {
    cancel();
    this.totalTime = totalTime;
    run();
  }

  /// 销毁计时器
  void cancel() {
    if (timer != null) {
      timer?.cancel();
      timer = null;
    }
  }
}
