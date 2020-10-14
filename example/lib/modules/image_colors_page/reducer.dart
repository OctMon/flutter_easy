import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<ImageColorsState> buildReducer() {
  return asReducer(
    <Object, Reducer<ImageColorsState>>{
      ImageColorsAction.updateFile: _updateFile,
      ImageColorsAction.updatePaletteGenerator: _updatePaletteGenerator,
    },
  );
}

ImageColorsState _updateFile(ImageColorsState state, Action action) {
  final ImageColorsState newState = state.clone();
  newState.file = action.payload;
  return newState;
}

ImageColorsState _updatePaletteGenerator(
    ImageColorsState state, Action action) {
  final ImageColorsState newState = state.clone();
  newState.paletteGenerator = action.payload;
  return newState;
}
