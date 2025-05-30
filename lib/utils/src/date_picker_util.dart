import 'package:flutter/material.dart';

import '../../../flutter_easy.dart';
import 'picker/time_picker/base_date_picker_constants.dart';

export 'picker/time_picker/date_picker/base_date_picker.dart';

void showBaseDatePicker({
  /// If rootNavigator is set to true, the state from the furthest instance of this class is given instead.
  /// Useful for pushing contents above all subsequent instances of [Navigator].
  bool rootNavigator = false,

  /// 选择弹窗标题
  String title = "",

  /// 点击弹框外部区域能否消失
  bool? canBarrierDismissible,

  /// 能滚动到的最小日期
  DateTime? minDateTime,

  /// 能滚动到的最大日期
  DateTime? maxDateTime,

  /// 初始选择的时间。默认当前时间
  DateTime? initialDateTime,

  /// 时间格式化的格式
  String? dateFormat,

  /// 分钟间切换的差值
  int minuteDivider = 1,

  /// 时间选择组件显示的时间类型
  BaseDateTimePickerMode pickerMode = BaseDateTimePickerMode.date,

  /// 时间选择组件的主题样式
  BasePickerTitleConfig? pickerTitleConfig,

  /// 点击【取消】回调给调用方的回调事件
  VoidCallback? onCancel,

  /// 弹框点击外围消失的回调事件
  VoidCallback? onClose,

  /// 时间滚动选择时候的回调事件
  DateValueCallback? onChange,

  /// 点击【完成】回调给调用方的数据
  DateValueCallback? onConfirm,
  BasePickerConfig? themeData,
}) {
  if (dateFormat == null) {
    final index = [
      BaseDateTimePickerMode.date,
      BaseDateTimePickerMode.datetime,
      BaseDateTimePickerMode.time
    ].indexWhere((e) => e.index == pickerMode.index);
    if (index > -1)
      dateFormat = [
        "yyyy年,MMMM月,dd日",
        "yyyy年,MM月,dd日,HH时:mm分:ss秒",
        "HH:mm:ss",
      ][index];
  }
  BaseDatePicker.showDatePicker(
    Get.context!,
    rootNavigator: rootNavigator,
    canBarrierDismissible: canBarrierDismissible,
    maxDateTime: maxDateTime,
    minDateTime: minDateTime,
    initialDateTime: initialDateTime,
    dateFormat: dateFormat,
    minuteDivider: minuteDivider,
    pickerMode: pickerMode,
    pickerTitleConfig: pickerTitleConfig ??
        BasePickerTitleConfig.defaultConfig.copyWith(
          titleContent: title,
        ),
    onCancel: onCancel,
    onClose: onClose,
    onChange: onChange,
    onConfirm: onConfirm,
    themeData: themeData,
  );
}
