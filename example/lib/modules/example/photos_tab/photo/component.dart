import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/store/user/store.dart';

import '../../../../routes.dart';
import 'controller.dart';

class PhotoComponent extends StatelessWidget {
  final String url;

  const PhotoComponent({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PhotoController(), tag: url);
    return Column(
      children: [
        Text(
          "random:${controller.state}",
          style: appTheme(context).textTheme.displayMedium,
        ),
        controller.baseState(
          (state) {
            return GestureDetector(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  BaseWebImage(
                    url,
                    placeholder: const Center(child: BaseLoadingView()),
                    fit: BoxFit.fill,
                  ),
                  Text("$url}"),
                ],
              ),
              onTap: () {
                UserStore.find.user.update((user) {
                  if (user != null) {
                    user.avatar = url;
                    UserStore.find.save(user);
                  }
                });
                toGalleryView(images: [url]);
              },
            );
          },
        ),
        Expanded(
          child: ListView(
            children: List.generate(
              100,
              (index) {
                final size = (randomInt(screenWidthDp.toInt()) + 100) * 3;
                return BaseWebImage("http://placekitten.com/$size/$size");
              },
            ).toList(),
          ),
        ),
      ],
    );
  }
}
