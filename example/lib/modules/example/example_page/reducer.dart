import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<ExampleState> buildReducer() {
  return asReducer(
    <Object, Reducer<ExampleState>>{
      ExampleAction.action: _onAction,
    },
  );
}

ExampleState _onAction(ExampleState state, Action action) {
  final ExampleState newState = state.clone();
  return newState;
}
