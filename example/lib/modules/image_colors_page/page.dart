import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class ImageColorsPage extends Page<ImageColorsState, Map<String, dynamic>> {
  ImageColorsPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<ImageColorsState>(
                adapter: null,
                slots: <String, Dependent<ImageColorsState>>{
                }),
            middleware: <Middleware<ImageColorsState>>[
            ],);

}
