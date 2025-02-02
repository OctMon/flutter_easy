import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:palette_generator/palette_generator.dart';

class ImageColorsController extends GetxController {
  final imagePath = "".obs;
  Rx<PaletteGenerator>? paletteGenerator;

  Future<void> updateFile(File file) async {
    showLoading();
    if (isWeb) {
      paletteGenerator = (await PaletteGenerator.fromImageProvider(
        NetworkImage(file.path),
        maximumColorCount: 200,
      ))
          .obs;
    } else {
      paletteGenerator = (await PaletteGenerator.fromImageProvider(
        FileImage(file),
        maximumColorCount: 200,
      ))
          .obs;
    }
    imagePath.value = file.path;
    dismissLoading();
  }
}
