import 'dart:ui';

import 'package:fish_redux/fish_redux.dart';

enum RootAction {
  onLocaleChange,
  updateCurrentIndex,
  onSelectedIndex,
}

class RootActionCreator {
  static Action onLocaleChange(Locale locale) {
    return Action(RootAction.onLocaleChange, payload: locale);
  }

  static Action updateCurrentIndex(int index) {
    return Action(RootAction.updateCurrentIndex, payload: index);
  }

  static Action onSelectedIndex(int index) {
    return Action(RootAction.onSelectedIndex, payload: index);
  }
}
