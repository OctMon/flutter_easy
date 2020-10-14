import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<ExampleState> buildEffect() {
  return combineEffects(<Object, Effect<ExampleState>>{
    ExampleAction.action: _onAction,
  });
}

void _onAction(Action action, Context<ExampleState> ctx) {
}
