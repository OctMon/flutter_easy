import 'dart:io';

import 'package:fish_redux/fish_redux.dart';
import 'package:palette_generator/palette_generator.dart';

enum ImageColorsAction { action, updateFile, updatePaletteGenerator }

class ImageColorsActionCreator {
  static Action onAction() {
    return const Action(ImageColorsAction.action);
  }

  static Action updateFile(File file) {
    return Action(ImageColorsAction.updateFile, payload: file);
  }

  static Action updatePaletteGenerator(PaletteGenerator paletteGenerator) {
    return Action(ImageColorsAction.updatePaletteGenerator,
        payload: paletteGenerator);
  }
}
