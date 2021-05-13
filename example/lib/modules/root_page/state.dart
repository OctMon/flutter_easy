import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_easy/flutter_easy.dart';

class RootState implements Cloneable<RootState> {
  /// 当前下标
  late int currentIndex;

  /// 闪屏页倒计时
  int? countDown;

  /// 计时器⌛️
  TimerUtil? timer;

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
