import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'model.dart';
import 'state.dart';

Reducer<UserState> buildReducer() {
  return asReducer(
    <Object, Reducer<UserState>>{
      UserAction.setUser: _setUser,
    },
  );
}

UserState _setUser(UserState state, Action action) {
  final UserModel entity = action.payload;
  return state.clone()..user = entity;
}
