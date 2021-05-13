import 'package:fish_redux/fish_redux.dart';

import 'model.dart';
export 'model.dart';

abstract class UserBaseState {
  UserModel? get user;

  set user(UserModel? user);
}

class UserState implements UserBaseState, Cloneable<UserState> {
  @override
  UserModel? user;

  bool get isLogin => user != null;

  @override
  UserState clone() {
    return UserState()..user = user;
  }
}

UserState initState(Map<String, dynamic> args) {
  return UserState();
}
