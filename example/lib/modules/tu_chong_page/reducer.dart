import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_easy/flutter_easy.dart';

// import 'action.dart';
import 'state.dart';

Reducer<TuChongState> buildReducer() {
  return asReducer(
    <Object, Reducer<TuChongState>>{
      BaseAction.updateState: updateBaseState,
    },
  );
}

// TuChongState _onAction(TuChongState state, Action action) {
//   final TuChongState newState = state.clone();
//   return newState;
// }
