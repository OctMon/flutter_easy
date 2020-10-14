import 'package:fish_redux/fish_redux.dart';

import 'state.dart';
import 'view.dart';

class TuChongTileComponent extends Component<TuChongTileState> {
  TuChongTileComponent()
      : super(
            view: buildView,
            dependencies: Dependencies<TuChongTileState>(
                adapter: null,
                slots: <String, Dependent<TuChongTileState>>{
                }),);

}
