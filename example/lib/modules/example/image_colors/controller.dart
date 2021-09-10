import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:palette_generator/palette_generator.dart';

class ImageColorsController extends GetxController {
  final imagePath = "".obs;
  Rx<PaletteGenerator>? paletteGenerator;

  Future<void> updateFile(File file) async {
    showLoading();
    PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      FileImage(file),
      size: null,
      region: null,
      maximumColorCount: 200,
    );
    imagePath.value = file.path;
    this.paletteGenerator = paletteGenerator.obs;
    dismissLoading();
  }
}
