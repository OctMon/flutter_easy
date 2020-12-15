import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/api/http_bin/http_bin_api.dart';
import 'action.dart';
import 'state.dart';

Effect<RootState> buildEffect() {
  return combineEffects(<Object, Effect<RootState>>{
    Lifecycle.initState: _initState,
    RootAction.onLocaleChange: _onLocaleChange,
    RootAction.onSelectedIndex: _onSelectedIndex,
  });
}

Future<void> _initState(Action action, Context<RootState> ctx) async {
  Result result = await getHttpBin(path: kHttpBinIp);
  if (result.response?.statusCode == 200) {
    showToast("${result.response}");
  }
}

void _onLocaleChange(Action action, Context<RootState> ctx) {
  ctx.forceUpdate();
}

void _onSelectedIndex(Action action, Context<RootState> ctx) {
  ctx.dispatch(RootActionCreator.updateCurrentIndex(action.payload));
}
