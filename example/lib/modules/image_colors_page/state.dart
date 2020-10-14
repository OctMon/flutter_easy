import 'dart:io';

import 'package:fish_redux/fish_redux.dart';
import 'package:palette_generator/palette_generator.dart';

class ImageColorsState implements Cloneable<ImageColorsState> {
  File file;
  PaletteGenerator paletteGenerator;

  @override
  ImageColorsState clone() {
    return ImageColorsState()
      ..file = file
      ..paletteGenerator = paletteGenerator;
  }
}

ImageColorsState initState(Map<String, dynamic> args) {
  return ImageColorsState();
}
