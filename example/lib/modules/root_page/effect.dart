import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<RootState> buildEffect() {
  return combineEffects(<Object, Effect<RootState>>{
    RootAction.onLocaleChange: _onLocaleChange,
    RootAction.onSelectedIndex: _onSelectedIndex,
  });
}

void _onLocaleChange(Action action, Context<RootState> ctx) {
  ctx.forceUpdate();
}

void _onSelectedIndex(Action action, Context<RootState> ctx) {
  ctx.dispatch(RootActionCreator.updateCurrentIndex(action.payload));
}
