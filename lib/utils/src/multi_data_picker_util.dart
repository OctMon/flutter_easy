import 'package:flutter/material.dart';

import '../../../flutter_easy.dart';
import 'picker/base_multi_data_picker.dart';

export 'picker/base/base_picker_title_config.dart';

void showBaseMultiDataPicker({
  /// 多级数据选择数据源
  required List<List<String>> list,

  /// 多级数据选择默认选中的索引数组，例如：[0,1] 表示第一层选中第一个，第二层选中第二个；
  List<int>? selectedIndexList,

  /// 多级数据选择弹窗标题
  String title = "",

  ///多级数据选择标题文案样式
  TextStyle? titleTextStyle,

  ///多级数据选择确认文案样式
  TextStyle? confirmTextStyle,

  ///多级数据选择取消文案样式
  TextStyle? cancelTextStyle,

  /// 多级数据选择每一级的默认标题
  List<String>? pickerTitles,

  /// 多级数据选择每一级默认标题的字体大小
  double? pickerTitleFontSize,

  /// 多级数据选择每一级默认标题的文案颜色
  Color? pickerTitleColor,

  /// 多级数据选择数据字体大小
  double? textFontSize,

  /// 多级数据选择数据文案颜色
  Color? textColor,

  /// 多级数据选择数据选中文案颜色
  Color? textSelectedColor,

  /// 多级数据选择确认点击回调
  BaseConfirmButtonClick? confirmClick,

  /// 选择轮盘的滚动行为
  ScrollBehavior? behavior,

  /// 返回自定义 itemWidget 的回调
  BaseMultiDataPickerCreateWidgetCallback? createItemWidget,

  /// 是否复位数据位置
  bool sync = true,
  bool isDismissible = true,
}) {
  BaseMultiDataPicker(
    context: Get.context!,
    delegate: _CustomDelegate(list: list, selectedIndexList: selectedIndexList),
    title: title,
    titleTextStyle: titleTextStyle,
    confirmTextStyle: confirmTextStyle,
    cancelTextStyle: cancelTextStyle,
    pickerTitles: pickerTitles,
    pickerTitleFontSize: pickerTitleFontSize,
    pickerTitleColor: pickerTitleColor,
    textFontSize: textFontSize,
    textColor: textColor,
    textSelectedColor: textSelectedColor,
    behavior: behavior,
    confirmClick: confirmClick,
    createItemWidget: createItemWidget,
    sync: sync,
  ).show(isDismissible: isDismissible);
}

class _CustomDelegate implements BaseMultiDataPickerDelegate {
  final List<List<String>> list;
  List<int>? selectedIndexList;

  _CustomDelegate({required this.list, this.selectedIndexList});

  @override
  int numberOfComponent() {
    return list.length;
  }

  @override
  int numberOfRowsInComponent(int component) {
    return list[component].length;
  }

  @override
  String titleForRowInComponent(int component, int index) {
    return list[component][index];
  }

  @override
  double? rowHeightForComponent(int component) {
    return null;
  }

  @override
  selectRowInComponent(int component, int row) {
    selectedIndexList ??= List.generate(list.length, (index) => 0);
    selectedIndexList?[component] = row;
  }

  @override
  int initSelectedRowForComponent(int component) {
    selectedIndexList ??= List.generate(list.length, (index) => 0);
    return selectedIndexList?[component] ?? 0;
  }
}
