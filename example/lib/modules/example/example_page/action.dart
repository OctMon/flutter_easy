import 'package:fish_redux/fish_redux.dart';

enum ExampleAction { action, onLocaleChange }

class ExampleActionCreator {
  static Action onAction() {
    return const Action(ExampleAction.action);
  }

  static Action onLocaleChange() {
    return const Action(ExampleAction.onLocaleChange);
  }
}
