import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class ExamplePage extends Page<ExampleState, Map<String, dynamic>> {
  ExamplePage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<ExampleState>(
                adapter: null,
                slots: <String, Dependent<ExampleState>>{
                }),
            middleware: <Middleware<ExampleState>>[
            ],);

}
