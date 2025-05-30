import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

import 'generated/l10n.dart';

class ExampleController extends GetxController {}

class ExamplePage extends StatelessWidget {
  ExamplePage({super.key});

  final controller = Get.put(ExampleController());

  @override
  Widget build(BuildContext context) {
    if (!isAppDebugFlag) {
      return const SizedBox.shrink();
    }

    return BaseScaffold(
      appBar: BaseAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Column(
            children: exampleList,
          ),
          SizedBox(height: 15),
          Text(
            "${S.of(context).home} Thin = w100",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: fontWeightThin,
            ),
          ),
          Text(
            "${S.of(context).home} ExtraLight = w200",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: fontWeightExtraLight,
            ),
          ),
          Text(
            "${S.of(context).home} Light = w300",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: fontWeightLight,
            ),
          ),
          Text(
            "${S.of(context).home} Regular = w400",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: fontWeightRegular,
            ),
          ),
          Text(
            "${S.of(context).home} Medium = w500",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: fontWeightMedium,
            ),
          ),
          Text(
            "${S.of(context).home} Semi-bold = w600",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: fontWeightSemiBold,
            ),
          ),
          Text(
            "${S.of(context).home} Bold = w700",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: fontWeightBold,
            ),
          ),
          Text(
            "${S.of(context).home} Extra-bold = w800",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: fontWeightBlack,
            ),
          ),
          Text(
            "${S.of(context).home} Black = w900",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

List<BaseExampleWrap> get exampleList {
  if (isDebug) {
    return [
      BaseExampleWrap(
        title: "",
        children: [
          BaseKeyValue(
            key: "数据越界",
            value: "触发异常",
            extend: () async {
              showInfoToast("异常触发中");
              showErrorToast("${[1][1]}");
              showSuccessToast("异常已触发");
            },
          ),
          BaseKeyValue(
            key: "分享",
            value: "APP",
            extend: () async {
              shareApp();
            },
          ),
          BaseKeyValue(
            key: "分享",
            value: "URL",
            extend: () async {
              shareURL("https://www.octmon.com/");
            },
          ),
          BaseKeyValue(
            key: "分享",
            value: "文本",
            extend: () async {
              shareText("text", subject: "subject");
            },
          ),
          BaseKeyValue(
            key: "分享",
            value: "文件",
            extend: () async {
              shareFile(
                  url:
                      "https://picsum.photos/${(screenWidthDp * screenDevicePixelRatio).round()}/${(screenHeightDp * screenDevicePixelRatio).round()}.jpg");
            },
          ),
        ],
      ),
      BaseExampleWrap(
        title: "",
        children: [
          BaseKeyValue(
            key: "Toast",
            value: "样式",
            extend: () async {
              showToast("我是个toast");
            },
          ),
          BaseKeyValue(
            key: "Toast",
            value: "Notification",
            extend: () async {
              showNotificationTextToast("我是个NotificationToast");
            },
          ),
        ],
      ),
      BaseExampleWrap(
        title: "",
        children: [
          BaseKeyValue(
            key: "底部弹出",
            value: "滚动选择",
            extend: () async {
              final list = [
                List.generate(10, (index) => "一级${index + 1}"),
                List.generate(10, (index) => "二级${index + 1}"),
              ];
              showBaseMultiDataPicker(
                list: list,
                selectedIndexList: [1, 2],
                confirmClick: (List selectedIndexList) {
                  final index1 = selectedIndexList[0];
                  final index2 = selectedIndexList[1];
                  logDebug(
                      "一级：$index1 - ${list[0][index1]} 二级：$index2 - ${list[1][index2]}");
                },
              );
            },
          ),
          // BaseKeyValue(
          //   key: "底部弹出",
          //   value: "日期选择",
          //   extend: () async {
          //     showBaseDatePicker(
          //       pickerMode: BaseDateTimePickerMode.datetime,
          //       onConfirm: (dateTime, list) {
          //         showToast("onConfirm:  $dateTime   $list");
          //         logDebug(dateTime);
          //       },
          //       onClose: () {
          //         logDebug("onClose");
          //       },
          //       onCancel: () {
          //         logDebug("onCancel");
          //       },
          //       onChange: (dateTime, list) {
          //         logDebug("onChange:  $dateTime    $list");
          //       },
          //     );
          //   },
          // ),
        ],
      ),
    ];
  }
  return [];
}
