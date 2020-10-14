import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<LoginState> buildReducer() {
  return asReducer(
    <Object, Reducer<LoginState>>{
      LoginAction.updateAgreementCheck: _updateAgreementCheck,
    },
  );
}

LoginState _updateAgreementCheck(LoginState state, Action action) {
  final LoginState newState = state.clone();
  newState.isChecked = action.payload;
  return newState;
}
