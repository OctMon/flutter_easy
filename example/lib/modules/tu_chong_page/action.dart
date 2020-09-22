import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum TuChongAction { action }

class TuChongActionCreator {
  static Action onAction() {
    return const Action(TuChongAction.action);
  }
}
