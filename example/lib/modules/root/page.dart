import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/generated/l10n.dart';
import 'package:flutter_easy_example/modules/account/page.dart';
import 'package:flutter_easy_example/modules/example/example_list/page.dart';
import 'package:flutter_easy_example/modules/home/page.dart';
import 'package:get/get.dart';

import 'controller.dart';

class RootPage extends StatelessWidget {
  final RootController controller = Get.put(RootController());

  @override
  Widget build(BuildContext context) {
    String url =
        "https://picsum.photos/${(screenWidthDp * screenDevicePixelRatio).round()}/${(screenHeightDp * screenDevicePixelRatio).round()}";
    return GetX<RootController>(
      builder: (controller) {
        if (controller.countDown.value == -1 || controller.countDown > 0) {
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
                visible: controller.countDown.value != -1,
                child: Align(
                  alignment: Alignment.topRight,
                  child: BaseButton(
                    padding: EdgeInsets.only(top: 35, right: 20),
                    child: Text(controller.countDown.value == -1
                        ? ""
                        : '${controller.timer?.isActive}: skip(${controller.countDown})'),
                    onPressed: () {
                      controller.countDown.value = 0;
                      controller.timer?.cancel();
                    },
                  ),
                ),
              ),
            ],
          );
        } else {
          final List<String> titles = [
            S.of(context).home,
            S.of(context).example,
            S.of(context).account
          ];

          const List<IconData> icons = [
            Icons.home,
            Icons.apps,
            Icons.account_circle
          ];

          final List<Widget> children = [
            HomePage(),
            ExampleListPage(),
            AccountPage(),
          ];

          return ObxValue<Rx<int>>((data) {
            return Scaffold(
              backgroundColor: colorWithScaffoldBackground,
              body: IndexedStack(
                index: data.value,
                children: children,
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                selectedFontSize: 12,
                selectedItemColor: colorWithTint,
                currentIndex: data.value,
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
                onTap: (index) {
                    data.value = index;
                    controller.currentIndex.value = index;
                },
              ),
            );
          }, controller.currentIndex);
        }
      },
    );
  }
}
