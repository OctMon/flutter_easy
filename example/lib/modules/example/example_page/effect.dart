import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<ExampleState> buildEffect() {
  return combineEffects(<Object, Effect<ExampleState>>{
    ExampleAction.onLocaleChange: _onLocaleChange,
  });
}

void _onLocaleChange(Action action, Context<ExampleState> ctx) {
  ctx.forceUpdate();
}
