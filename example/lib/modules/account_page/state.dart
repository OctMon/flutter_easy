import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_easy_example/store/user_store/state.dart';

class AccountState implements UserBaseState, Cloneable<AccountState> {
  @override
  AccountState clone() {
    return AccountState()..user = user;
  }

  @override
  UserModel user;
}

AccountState initState(Map<String, dynamic> args) {
  return AccountState();
}
