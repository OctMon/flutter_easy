import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_easy_example/api/tu_chong/tu_chong_model.dart';

class TuChongTileState implements Cloneable<TuChongTileState> {
  TuChongModel data;

  @override
  TuChongTileState clone() {
    return TuChongTileState()..data = data;
  }
}
