import 'package:flutter_easy/flutter_easy.dart';

import '../../../api/service/image.dart';
import '../../../models/girl_list_model.dart';

class ImageGirlListLogic
    extends BaseRefreshStateController<List<GirlListModel>> {
  @override
  Future<void> onRequestPage(int page) async {
    Result result = await ImageService().girlList(page: page);
    updateRefreshResult(result, page: page);
  }
}
