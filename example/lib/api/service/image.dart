import 'package:flutter_easy/flutter_easy.dart';

import '../../api/api.dart';
import '../../models/girl_list_model.dart';

extension _PathExtension on String {
  String get api => "image/$this".baseApi;
}

/// 美女图片福利
class ImageService {
  //┌┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄

  String get _kGirlListRandom => "girl/list/random".api;

  String get _kGirlList => "girl/list".api;

  //├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄

  /// 随机获取福利图片
  Future<Result> girlListRandom() async {
    final result = await get(
      path: _kGirlListRandom,
    );
    result.fillMap(
      (json) => GirlListModel.fromJson(json),
    );
    return result;
  }

  /// 获取福利图片列表
  Future<Result> girlList({required int page}) async {
    final result = await get(
      path: _kGirlList,
      queryParameters: {kPageKey: page},
    );
    result.fillMap(
      (json) {
        final model = GirlListModel.fromJson(json);
        if (isWeb) {
          final width =
              randomInt((screenWidthDp * screenDevicePixelRatio).round()) + 1000;
          final height =
              randomInt((screenHeightDp * screenDevicePixelRatio).round()) + 1000;
          model..imageSize="${width}x$height"..imageUrl = "https://picsum.photos/$width/$height";
        }
        return model;
      },
    );

    return result;
  }

//└───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
}
