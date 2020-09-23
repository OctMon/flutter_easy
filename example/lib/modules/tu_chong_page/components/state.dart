import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_easy_example/api/tu_chong/tu_chong_model.dart';

class TuChongTileState implements Cloneable<TuChongTileState> {
  List<ImagesBean> images;

  @override
  TuChongTileState clone() {
    return TuChongTileState()..images = images;
  }
}
