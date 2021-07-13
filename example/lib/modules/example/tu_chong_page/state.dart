import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/api/tu_chong/tu_chong_model.dart';
import 'components/state.dart';

class TuChongState extends MutableSource
    with BaseRefreshState<EasyRefreshController, List<TuChongModel>>
    implements Cloneable<TuChongState> {
  int postId;

  @override
  TuChongState clone() {
    return TuChongState()
      ..postId = postId
      ..data = data
      ..message = message
      ..page = page
      ..refreshController = refreshController;
  }

  @override
  List<TuChongModel> data;

  @override
  String message;

  @override
  int page;

  @override
  EasyRefreshController refreshController;

  @override
  Object getItemData(int index) {
    return TuChongTileState()..data = data[index];
  }

  @override
  String getItemType(int index) {
    return "tile";
  }

  @override
  int get itemCount => data?.length ?? 0;

  @override
  void setItemData(int index, Object data) {
    // TODO: implement setItemData
  }
}

TuChongState initState(Map<String, dynamic> args) {
  return TuChongState()..refreshController = EasyRefreshController();
}
