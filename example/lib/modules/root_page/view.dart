import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(RootState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    backgroundColor: colorWithScaffoldBackground,
    body: IndexedStack(index: state.currentIndex, children: state.tabBodies),
    bottomNavigationBar: BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: state.currentIndex,
      items: state.tabBarItems,
      onTap: (index) => dispatch(RootActionCreator.updateCurrentIndex(index)),
    ),
  );;
}
