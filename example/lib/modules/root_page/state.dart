import 'package:fish_redux/fish_redux.dart';

class RootState implements Cloneable<RootState> {
  /// 当前下标
  int currentIndex;

  @override
  RootState clone() {
    return RootState()
      ..currentIndex = currentIndex;
  }
}

RootState initState(Map<String, dynamic> args) {
  return RootState()
    ..currentIndex = 0;
}
