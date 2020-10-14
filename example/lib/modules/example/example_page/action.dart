import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum ExampleAction { action }

class ExampleActionCreator {
  static Action onAction() {
    return const Action(ExampleAction.action);
  }
}
