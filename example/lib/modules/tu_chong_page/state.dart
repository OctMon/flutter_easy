import 'package:fish_redux/fish_redux.dart';

class TuChongState implements Cloneable<TuChongState> {

  @override
  TuChongState clone() {
    return TuChongState();
  }
}

TuChongState initState(Map<String, dynamic> args) {
  return TuChongState();
}
