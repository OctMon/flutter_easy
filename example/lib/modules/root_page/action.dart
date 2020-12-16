import 'package:fish_redux/fish_redux.dart';

enum RootAction {
  onLocaleChange,
  updateCurrentIndex,
  onSelectedIndex,
  updateCountdown,
}

class RootActionCreator {
  static Action onLocaleChange() {
    return const Action(RootAction.onLocaleChange);
  }

  static Action updateCurrentIndex(int index) {
    return Action(RootAction.updateCurrentIndex, payload: index);
  }

  static Action onSelectedIndex(int index) {
    return Action(RootAction.onSelectedIndex, payload: index);
  }

  static Action updateCountdown(int count) {
    return Action(RootAction.updateCountdown, payload: count);
  }
}
