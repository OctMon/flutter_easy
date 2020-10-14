import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_easy_example/app.dart';
import 'package:flutter_easy_example/modules/root_page/action.dart';
import 'action.dart';
import 'state.dart';

Effect<AccountState> buildEffect() {
  return combineEffects(<Object, Effect<AccountState>>{
    AccountAction.onLocaleChange: _onLocaleChange,
  });
}

void _onLocaleChange(Action action, Context<AccountState> ctx) {
  onLocaleChange(action.payload);
  ctx.forceUpdate();
  ctx.broadcast(RootActionCreator.onLocaleChange(action.payload));
}
