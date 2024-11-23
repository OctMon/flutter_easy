import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/generated/l10n.dart';
import 'package:flutter_easy_example/modules/account/view.dart';
import 'package:flutter_easy_example/modules/example/example_list/view.dart';
import 'package:flutter_easy_example/modules/home/view.dart';

import 'controller.dart';

class RootPage extends StatelessWidget {
  final RootController controller = Get.put(RootController());

  RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    // routesInterceptOffBack = () {
    //   logDebug("routesInterceptOffBack");
    //   Navigator.of(context).pop();
    // };
    logInfo("appDarkMode: ${appDarkMode(context)}");
    final List<String> titles = [
      S.of(context).home,
      S.of(context).example,
      S.of(context).account
    ];

    const List<IconData> icons = [Icons.home, Icons.apps, Icons.account_circle];

    final List<Widget> children = [
      HomePage(),
      const ExampleListPage(),
      AccountPage(),
    ];

    return BaseNavigatorPopExit(
      child: ObxValue<Rx<int>>((data) {
        return BaseScaffold(
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
      }, controller.currentIndex),
    );
  }
}
