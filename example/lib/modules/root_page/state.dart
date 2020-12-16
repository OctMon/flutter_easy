import 'dart:async';

import 'package:fish_redux/fish_redux.dart';

class RootState implements Cloneable<RootState> {
  /// 当前下标
  int currentIndex;

  /// 闪屏页倒计时
  int countDown;

  Timer timer;

  @override
  RootState clone() {
    return RootState()
      ..currentIndex = currentIndex
      ..countDown = countDown
      ..timer = timer;
  }
}

RootState initState(Map<String, dynamic> args) {
  return RootState()..currentIndex = 0;
}
