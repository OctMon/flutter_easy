import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/api/tu_chong/tu_chong_api.dart';
import 'package:flutter_easy_example/api/tu_chong/tu_chong_model.dart';
import 'action.dart';
import 'state.dart';

Effect<TuChongState> buildEffect() {
  return combineEffects(<Object, Effect<TuChongState>>{
    Lifecycle.initState: _initState,
    BaseAction.onRequestData: _onRequestData,
  });
}

void _initState(Action action, Context<TuChongState> ctx) {
  _onRequestData(action, ctx);
}

Future<void> _onRequestData(Action action, Context<TuChongState> ctx) async {
  ctx.state.page = action.payload;
  Result result = await getAPI(path: kApiFeedApp, queryParameters: {
    "page": ctx.state.page,
    "pose_id": ctx.state.postId ?? 0
  })
    ..fillMap((json) => TuChongModel.fromJson(json));

  ctx.dispatch(TuChongActionCreator.updateState(ctx.state.clone()
    ..postId = ((result.models as List<TuChongModel>).last.postId)
    ..updateResult(result, hasMore: result.valid)));
}
