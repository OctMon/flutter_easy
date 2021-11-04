import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/utils/user/service.dart';
import 'package:get/get.dart';

import 'controller.dart';
import 'photo/component.dart';

class PhotosTabPage extends StatelessWidget {
  final controller = Get.put(PhotosTabController());

  PhotosTabPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabs = List.generate(10, (index) {
      final width =
          (screenWidthDp * screenDevicePixelRatio * index * 0.1).round();
      return "https://picsum.photos/$width/$width";
    });
    return BaseScaffold(
      backgroundColor: Colors.white,
      appBar: BaseAppBar(
        height: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            BaseTabPage(
              tabBarHeight: 44,
              isScrollable: true,
              tabs: tabs.map(
                (e) {
                  return Text(e.split("/").last);
                },
              ).toList(),
              children: tabs.map(
                (url) {
                  return PhotoComponent(url: url);
                },
              ).toList(),
            ),
            Obx(() {
              return Align(
                alignment: Alignment.bottomRight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: BaseWebImage(
                    UserService.find.user.value.avatar,
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
