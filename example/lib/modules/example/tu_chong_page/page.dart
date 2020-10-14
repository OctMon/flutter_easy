import 'package:fish_redux/fish_redux.dart';

import 'adapter.dart';
import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class TuChongPage extends Page<TuChongState, Map<String, dynamic>> {
  TuChongPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<TuChongState>(
              adapter: NoneConn<TuChongState>() + TuChongAdapter(),
              slots: <String, Dependent<TuChongState>>{}),
          middleware: <Middleware<TuChongState>>[],
        );
}
