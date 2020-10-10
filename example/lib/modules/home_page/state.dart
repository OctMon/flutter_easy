import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/widgets.dart';

class HomeState implements Cloneable<HomeState> {
  AnimationController animationController;

  @override
  HomeState clone() {
    return HomeState()..animationController = animationController;
  }
}

HomeState initState(Map<String, dynamic> args) {
  return HomeState();
}
