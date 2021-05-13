import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/widgets.dart' hide Action;
import 'action.dart';
import 'state.dart';

Effect<HomeState> buildEffect() {
  return combineEffects(<Object, Effect<HomeState>>{
    Lifecycle.initState: _initState,
    Lifecycle.build: _build,
    Lifecycle.dispose: _dispose,
    HomeAction.action: _onAction,
  });
}

void _initState(Action action, Context<HomeState> ctx) {
  final TickerProvider ticker = ctx.stfState as TickerProvider;
  ctx.state.animationController = AnimationController(
      vsync: ticker, duration: Duration(milliseconds: 2000));
}

void _build(Action action, Context<HomeState> ctx) {
  Future.delayed(Duration(milliseconds: 0),
      () => ctx.state.animationController?.repeat(reverse: true));
}

void _dispose(Action action, Context<HomeState> ctx) {
  ctx.state.animationController?.dispose();
}

void _onAction(Action action, Context<HomeState> ctx) {}
