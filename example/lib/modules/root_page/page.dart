import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class RootPage extends Page<RootState, Map<String, dynamic>> {
  RootPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<RootState>(
                adapter: null,
                slots: <String, Dependent<RootState>>{
                }),
            middleware: <Middleware<RootState>>[
            ],);

}
