import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/api/tu_chong/tu_chong_model.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
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
  // List<TuChongModel> data;


  @override
  int page;

  @override
  EasyRefreshController refreshController;

  @override
  Object getItemData(int index) {
    return TuChongTileState()..data = data.value[index];
  }

  @override
  String getItemType(int index) {
    return "tile";
  }

  @override
  int get itemCount => data.value?.length ?? 0;

  @override
  void setItemData(int index, Object data) {
    // TODO: implement setItemData
  }

  @override
  Rx<List<TuChongModel>> data;

  @override
  Rx<String> message;

  @override
  RxList<List<TuChongModel>> list;
}

TuChongState initState(Map<String, dynamic> args) {
  return TuChongState()..refreshController = EasyRefreshController();
}
