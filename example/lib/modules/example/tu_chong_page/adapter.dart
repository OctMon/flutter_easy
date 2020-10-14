import 'package:fish_redux/fish_redux.dart';

import 'state.dart';
import 'components/component.dart';

class TuChongAdapter extends SourceFlowAdapter<TuChongState> {
  TuChongAdapter()
      : super(
          pool: <String, Component<Object>>{
            "tile": TuChongTileComponent()
          },
        );
}
