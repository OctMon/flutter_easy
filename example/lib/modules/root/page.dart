import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/generated/l10n.dart';
import 'package:flutter_easy_example/modules/account/page.dart';
import 'package:flutter_easy_example/modules/example/example_list/page.dart';
import 'package:flutter_easy_example/modules/home/page.dart';

import 'controller.dart';

class RootPage extends StatelessWidget {
  final RootController controller = Get.put(RootController());

  RootPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logInfo("appDarkMode: $appDarkMode");
    final List<String> titles = [
      S.of(context).home,
      S.of(context).example,
      S.of(context).account
    ];

    const List<IconData> icons = [Icons.home, Icons.apps, Icons.account_circle];

    final List<Widget> children = [
      HomePage(),
      const ExampleListPage(),
      const AccountPage(),
    ];

    return ObxValue<Rx<int>>((data) {
      return Scaffold(
        body: IndexedStack(
          index: data.value,
          children: children,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          selectedItemColor: appTheme(context).indicatorColor,
          currentIndex: data.value,
          items: List.generate(titles.length, (index) {
            return BottomNavigationBarItem(
              icon: Icon(icons[index]),
              activeIcon: Icon(
                icons[index],
                color: appTheme(context).indicatorColor,
              ),
              label: titles[index],
              // title: Container(),
            );
          }),
          onTap: (index) {
            data.value = index;
            controller.currentIndex.value = index;
          },
        ),
      );
    }, controller.currentIndex);
  }
}
