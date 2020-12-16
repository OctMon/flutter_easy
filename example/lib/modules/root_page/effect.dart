import 'dart:async';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/api/http_bin/http_bin_api.dart';
import 'action.dart';
import 'state.dart';

Effect<RootState> buildEffect() {
  return combineEffects(<Object, Effect<RootState>>{
    Lifecycle.initState: _initState,
    Lifecycle.dispose: _dispose,
    RootAction.onLocaleChange: _onLocaleChange,
    RootAction.onSelectedIndex: _onSelectedIndex,
  });
}

void startCountdownTimer(Action action, Context<RootState> ctx) {
  int count = randomInt(5) + 3;
  ctx.dispatch(RootActionCreator.updateCountdown(count));

  var callback = (timer) {
    ctx.dispatch(RootActionCreator.updateCountdown(--count));
    if (count < 1) {
      timer?.cancel();
    }
  };

  ctx.state.timer = Timer.periodic(const Duration(seconds: 1), callback);
}

void _dispose(Action action, Context<RootState> ctx) {
  ctx.state.timer?.cancel();
}

Future<void> _initState(Action action, Context<RootState> ctx) async {
  startCountdownTimer(action, ctx);
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
