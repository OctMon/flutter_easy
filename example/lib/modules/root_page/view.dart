import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/generated/l10n.dart';
import 'package:flutter_easy_example/routes.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(RootState state, Dispatch dispatch, ViewService viewService) {
  AdaptUtil.initContext(viewService.context);

  if (state.countDown.isEmptyOrNull || state.countDown > 0) {
    String url =
        "https://picsum.photos/${(screenWidthDp * screenDevicePixelRatio).round()}/${(screenHeightDp * screenDevicePixelRatio).round()}";
    return Stack(
      children: [
        BaseLaunchRemote(
          keepLogo: false,
          url: url,
          onTap: () {
            showToast(url);
          },
        ),
        Visibility(
          visible: !state.countDown.isEmptyOrNull,
          child: Align(
            alignment: Alignment.topRight,
            child: BaseButton(
              padding: EdgeInsets.only(top: 35, right: 20),
              child: Text(
                  '${state.timer?.isActive}: skip(${state.countDown ?? ''})'),
              onPressed: () {
                dispatch(RootActionCreator.updateCountdown(0));
                state.timer?.cancel();
              },
            ),
          ),
        ),
      ],
    );
  }
  final List<String> titles = [
    S.of(viewService.context).home,
    S.of(viewService.context).example,
    S.of(viewService.context).account
  ];

  const List<IconData> icons = [Icons.home, Icons.apps, Icons.account_circle];

  final List<Widget> children = [
    Routes.routes.buildPage(Routes.home, null),
    Routes.routes.buildPage(Routes.example, null),
    Routes.routes.buildPage(Routes.account, null),
  ];

  return Scaffold(
    backgroundColor: colorWithScaffoldBackground,
    body: IndexedStack(index: state.currentIndex, children: children),
    bottomNavigationBar: BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 12,
      selectedItemColor: colorWithTint,
      currentIndex: state.currentIndex,
      items: List.generate(titles.length, (index) {
        return BottomNavigationBarItem(
          icon: Icon(icons[index]),
          activeIcon: Icon(
            icons[index],
            color: colorWithTint,
          ),
          label: titles[index],
          // title: Container(),
        );
      }),
      onTap: (index) => dispatch(RootActionCreator.updateCurrentIndex(index)),
    ),
  );
}
