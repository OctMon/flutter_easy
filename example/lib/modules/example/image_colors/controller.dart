import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palette_generator/palette_generator.dart';

class ImageColorsController extends GetxController {
  final imagePath = ''.obs;
  Rx<PaletteGenerator>? paletteGenerator;
  bool isPicking = false;

  Future<void> updateImage(XFile image) async {
    showLoading();
    try {
      // file_selector may return a system URI with bytes already attached.
      // Read through XFile rather than treating every result as a sandbox path.
      final bytes = await image.readAsBytes();
      final palette = await PaletteGenerator.fromImageProvider(
        ResizeImage(MemoryImage(bytes),
            width: 256, height: 256, policy: ResizeImagePolicy.fit),
        maximumColorCount: 200,
      );
      var path = image.path;
      if (!isWeb) {
        final directory = await getAppTemporaryDirectory();
        await directory.create(recursive: true);
        path = getJoin(directory.path,
            'picked_image_${DateTime.now().microsecondsSinceEpoch}${getExtension(image.name)}');
        await File(path).writeAsBytes(bytes);
      }
      if (isClosed) return;
      paletteGenerator = palette.obs;
      imagePath.value = path;
    } finally {
      dismissLoading();
    }
  }
}
