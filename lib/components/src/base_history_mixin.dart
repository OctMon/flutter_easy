import 'package:get/get.dart';

import '../../utils/src/logger_util.dart';
import '../../utils/src/storage_util.dart';
import 'base.dart';

const _kListKey = "list";

mixin BaseHistoryMixin {
  final history = <BaseKeyValue>[].obs;

  /// 历史记录key
  late String historyKey;

  /// 历史记录
  Future<void> loadHistory() async {
    var models = await getStorageList<BaseKeyValue>(historyKey,
        listKey: _kListKey, onModels: (json) {
      return BaseKeyValue.fromJson(json);
    });
    history.value = models;
    logDebug(
        "搜索加载历史记录: ${models.length} list: ${models.map((e) => e.toJson())}");
  }

  Future<void> _saveList() async {
    await setStorageList(historyKey,
        listKey: _kListKey, list: history.toList());
  }

  Future<void> saveHistory({required BaseKeyValue model}) async {
    logDebug("搜索保存历史记录: $model");
    var models = await getStorageList<BaseKeyValue>(historyKey,
        listKey: _kListKey, onModels: (json) {
      return BaseKeyValue.fromJson(json);
    });

    if (models.isNotEmpty) {
      final index = models.indexWhere((element) => element.key == model.key);
      if (index > -1) {
        models.removeAt(index);
      }
      models.insert(0, model);
    } else {
      models.insert(0, model);
    }
    history.value = models;
    _saveList();
  }

  Future<void> removeHistory(BaseKeyValue model) async {
    logDebug("搜索删除某个历史记录: $model");
    history.removeWhere((e) => e.key == model.key);
    await _saveList();
  }

  Future<void> clearHistory() async {
    logDebug("搜索删除全部历史记录: $history");
    history.clear();
    await removeStorage(historyKey);
  }
}
