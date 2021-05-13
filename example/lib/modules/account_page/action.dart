import 'dart:ui';

import 'package:fish_redux/fish_redux.dart';

enum AccountAction { action, onLocaleChange }

class AccountActionCreator {
  static Action onAction() {
    return const Action(AccountAction.action);
  }

  static Action onLocaleChange(Locale? locale) {
    return Action(AccountAction.onLocaleChange, payload: locale);
  }
}
