import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<RootState> buildReducer() {
  return asReducer(
    <Object, Reducer<RootState>>{
      RootAction.updateCurrentIndex: _updateCurrentIndex,
    },
  );
}

RootState _updateCurrentIndex(RootState state, Action action) {
  final RootState newState = state.clone();
  newState
    ..currentIndex = action.payload;
  return newState;
}
