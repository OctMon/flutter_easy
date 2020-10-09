import 'package:fish_redux/fish_redux.dart';

import 'model.dart';

enum UserAction { setUser }

class UserActionCreator {
  static Action setUser(UserModel user) {
    return Action(UserAction.setUser, payload: user);
  }
}
