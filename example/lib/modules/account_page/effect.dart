import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/modules/example/example_page/action.dart';
import 'package:flutter_easy_example/modules/root_page/action.dart';
import 'action.dart';
import 'state.dart';

Effect<AccountState> buildEffect() {
  return combineEffects(<Object, Effect<AccountState>>{
    AccountAction.onLocaleChange: _onLocaleChange,
  });
}

Future<void> _onLocaleChange(Action action, Context<AccountState> ctx) async {
  showLoading();
  await onLocaleChange(action.payload);
  ctx.broadcast(RootActionCreator.onLocaleChange());
  ctx.broadcast(ExampleActionCreator.onLocaleChange());
  ctx.forceUpdate();
  dismissLoading();
}
