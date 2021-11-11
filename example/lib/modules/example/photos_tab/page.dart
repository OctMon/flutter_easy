import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/store/user/store.dart';
import 'package:get/get.dart';

import 'controller.dart';
import 'photo/component.dart';

class PhotosTabPage extends StatelessWidget {
  final controller = Get.put(PhotosTabController());

  PhotosTabPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Color> colorList = [
      Colors.red,
      Colors.orange,
      Colors.green,
      Colors.purple,
      Colors.blue,
      Colors.yellow,
      Colors.pink,
      Colors.teal,
      Colors.deepPurpleAccent
    ];
    return BaseScaffold(
      appBar: BaseAppBar(),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: FlutterLogo(
                    size: screenWidthDp * 0.25,
                  ),
                ),
                SliverGrid.count(
                  crossAxisCount: 3,
                  children: colorList
                      .map((color) => Container(color: color))
                      .toList(),
                ),
                SliverFixedExtentList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Container(color: colorList[index]),
                    childCount: colorList.length,
                  ),
                  itemExtent: 100,
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: BaseSliverPersistentHeaderDelegate(
                    extent: 44,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      color: appTheme(context).scaffoldBackgroundColor,
                      child: TabBar(
                        controller: controller.tabController,
                        isScrollable: true,
                        labelStyle: TextStyle(
                          fontSize: 18.adaptRatio,
                          fontWeight: FontWeight.w600,
                        ),
                        unselectedLabelStyle: TextStyle(
                          fontSize: 18.adaptRatio,
                          fontWeight: FontWeight.normal,
                        ),
                        labelColor: appTheme(context).primaryColor,
                        unselectedLabelColor: colorWithHex6,
                        tabs: controller.tabs.map(
                          (e) {
                            return Text(e.split("/").last);
                          },
                        ).toList(),
                        // onTap: (index) {},
                      ),
                    ),
                  ),
                ),
                SliverFillRemaining(
                  child: TabBarView(
                    controller: controller.tabController,
                    children: controller.tabs.map(
                      (url) {
                        return PhotoComponent(url: url);
                      },
                    ).toList(),
                  ),
                ),
              ],
            ),
            Obx(() {
              return Align(
                alignment: Alignment.bottomRight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: BaseWebImage(
                    UserStore.find.user.value.avatar,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    placeholder: const FlutterLogo(size: 100),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
