import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:get/get.dart';

import 'controller.dart';

class PhotoComponent extends StatelessWidget {
  final controller = Get.put(PhotoController());
  final String url;

  PhotoComponent({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: BaseWebImage(
        url,
        width: screenWidthDp,
        height: screenHeightDp,
        placeholder: const Center(child: BaseLoadingView()),
        fit: BoxFit.fill,
      ),
      onTap: () {
        showToast(url);
      },
    );
  }
}
