import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<TuChongState> buildReducer() {
  return asReducer(
    <Object, Reducer<TuChongState>>{
      TuChongAction.action: _onAction,
    },
  );
}

TuChongState _onAction(TuChongState state, Action action) {
  final TuChongState newState = state.clone();
  return newState;
}
