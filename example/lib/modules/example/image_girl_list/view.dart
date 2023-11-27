import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

import '../../../routes.dart';
import 'logic.dart';

class ImageGirlListPage extends StatelessWidget {
  ImageGirlListPage({Key? key}) : super(key: key);

  final logic = Get.put(ImageGirlListLogic());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: Text(isWeb ? "Random" : "Girl list"),
      ),
      body: logic.baseRefreshState(
        (state) => BaseMasonryGridView.count(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 1,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          itemBuilder: (context, index) {
            final model = state?[index];
            if (model == null) {
              return SizedBox.shrink();
            }
            final width = (screenWidthDp - 30);

            // 1920x1080
            final imageSize = model.imageSize?.split("x") ?? [];
            final imageWidth = int.tryParse(imageSize.first) ?? width;
            final imageHeight = int.tryParse(imageSize.last) ?? width;

            return BaseButton(
              padding: EdgeInsets.zero,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  BaseWebImage.clip(
                    width: width,
                    height: width * imageHeight / imageWidth,
                    url: model.imageUrl,
                    borderRadius: 6,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              onPressed: () {
                toNamed(Routes.photoView, arguments: {
                  "data": state
                      ?.map((e) => BaseKeyValue(
                          key: e.imageSize ?? "", value: e.imageUrl ?? ""))
                      .toList(),
                  "index": index
                });
              },
            );
          },
          itemCount: state?.length ?? 0,
        ).paddingOnly(bottom: 85.adaptRatio),
        placeholderImagePath: assetsImagesPath("placeholder_appstore"),
      ),
    );
  }
}
