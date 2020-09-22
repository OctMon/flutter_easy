import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/routes.dart';

class RootState implements Cloneable<RootState> {
  /// 当前下标
  int currentIndex;

  /// 当前页
  Widget currentPage;

  /// 所有根页面
  List<Widget> tabBodies;

  /// 所有底部标签
  List<BottomNavigationBarItem> tabBarItems;

  @override
  RootState clone() {
    return RootState()
      ..currentIndex = currentIndex
      ..currentPage = currentPage
      ..tabBodies = tabBodies
      ..tabBarItems = tabBarItems;
  }
}

RootState initState(Map<String, dynamic> args) {
  List<String> titles = [
    "首页",
    "图虫",
  ];
  return RootState()
    ..currentIndex = 0
    ..tabBodies = [
      Routes.routes.buildPage(Routes.home, null),
      Routes.routes.buildPage(Routes.tuChong, null),
    ]
    ..tabBarItems = List.generate(titles.length, (index) {
      return BottomNavigationBarItem(
        icon: Column(
          children: <Widget>[
            Icon(Icons.home),
            BaseTitle(
              titles[index],
              fontSize: 12,
              color: Color(0xFFAAAAAA),
            )
          ],
        ),
        activeIcon: Column(
          children: <Widget>[
            Icon(Icons.home),
            BaseTitle(
              titles[index],
              fontSize: 12,
              color: colorWithTint,
            )
          ],
        ),
        title: Container(),
      );
    });
}
