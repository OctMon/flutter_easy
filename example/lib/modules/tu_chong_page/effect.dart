import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/api/tuchong_api.dart';
import 'package:flutter_easy_example/modules/tu_chong_page/model.dart';
import 'action.dart';
import 'state.dart';

Effect<TuChongState> buildEffect() {
  return combineEffects(<Object, Effect<TuChongState>>{
    Lifecycle.initState: _onAction,
    TuChongAction.action: _onAction,
  });
}

Future<void> _onAction(Action action, Context<TuChongState> ctx) async {
  Result result = await getApi(path: "feed-app", queryParameters: {kPageKey: 1})
    ..fillMap((json) => FeedModel.fromJson(json));
  logDebug(result.models.length);
}
