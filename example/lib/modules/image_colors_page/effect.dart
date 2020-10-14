import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<ImageColorsState> buildEffect() {
  return combineEffects(<Object, Effect<ImageColorsState>>{
    ImageColorsAction.action: _onAction,
  });
}

void _onAction(Action action, Context<ImageColorsState> ctx) {
}
