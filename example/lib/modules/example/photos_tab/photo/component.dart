import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/store/user/store.dart';
import 'package:get/get.dart';

import 'controller.dart';

class PhotoComponent extends StatelessWidget {
  final String url;

  const PhotoComponent({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PhotoController(), tag: url);
    return controller.baseState(
      (state) {
        return GestureDetector(
          child: Stack(
            children: [
              BaseWebImage(
                url,
                width: screenWidthDp,
                height: screenHeightDp,
                placeholder: const Center(child: BaseLoadingView()),
                fit: BoxFit.fill,
              ),
              Align(
                alignment: Alignment.center,
                child: Text("$state"),
              ),
            ],
          ),
          onTap: () {
            UserStore.find.user.update((user) {
              if (user != null) {
                user.avatar = url;
                UserStore.find.save(user);
              }
            });
            showToast(url);
          },
        );
      },
    );
  }
}
