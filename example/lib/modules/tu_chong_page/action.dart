import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_easy/flutter_easy.dart';

//TODO replace with your own action
// enum TuChongAction { action }

class TuChongActionCreator {
  // static Action onAction() {
  //   return const Action(TuChongAction.action);
  // }

  static Action onRequestData(int page) {
    return Action(BaseAction.onRequestData, payload: page);
  }

  static Action updateState(state) {
    return Action(BaseAction.updateState, payload: state);
  }
}
