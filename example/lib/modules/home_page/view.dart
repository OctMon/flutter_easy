import 'package:fish_redux/fish_redux.dart' hide isDebug;
import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/main.dart';

import 'state.dart';

Widget buildView(HomeState state, Dispatch dispatch, ViewService viewService) {
  TableRow buildTableRow({@required String code, @required String value}) {
    return TableRow(
      children: [
        Center(child: Container(margin: EdgeInsets.all(5), child: Text(code))),
        Center(child: Container(margin: EdgeInsets.all(5), child: Text(value))),
      ],
    );
  }

  Widget buildTableColumn({@required String code, @required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(code),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(fontSize: adaptDp(5.8)),
        ),
      ],
    );
  }

  TableRow buildTableRowTop({@required String code, @required String value}) {
    return TableRow(
      //第一行样式 添加背景色
      decoration: BoxDecoration(
        color: Colors.grey,
      ),
      children: [
        Center(child: Container(margin: EdgeInsets.all(5), child: Text(code))),
        Center(child: Text(value)),
      ],
    );
  }

  return BaseScaffold(
    appBar: BaseAppBar(
      leading: isSelectBaseURLTypeFlag
          ? IconButton(
              icon: Icon(Icons.developer_mode),
              onPressed: () {
                showSelectBaseURLTypeAlert(context: viewService.context)
                    .then((value) => main());
              },
            )
          : null,
      title: BaseText(appName),
    ),
    body: SafeArea(
      child: ListView(
        padding: EdgeInsets.all(15),
        children: <Widget>[
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: {
              // 0: FixedColumnWidth(adaptDp(130)),
            },
            border: TableBorder.all(
              color: colorWithTint,
              width: 1.0,
              style: BorderStyle.solid,
            ),
            children: [
              buildTableRowTop(code: "app", value: "value"),
              buildTableRow(code: "appName", value: appName),
              buildTableRow(code: "appPackageName", value: appPackageName),
              buildTableRow(code: "appBuildNumber", value: appBuildNumber),
              buildTableRow(code: "appVersion", value: appVersion),
              buildTableRowTop(code: "is", value: "value"),
              buildTableRow(code: "isProduction", value: "$isProduction"),
              buildTableRow(code: "isDebug", value: "$isDebug"),
              buildTableRow(code: "isAndroid", value: "$isAndroid"),
              buildTableRow(code: "isIOS", value: "$isIOS"),
              buildTableRow(code: "isWeb", value: "$isWeb"),
              buildTableRow(code: "isWebInAndroid", value: "$isWebInAndroid"),
              buildTableRow(code: "isWebInIos", value: "$isWebInIos"),
              buildTableRow(code: "isWebInIPhone", value: "$isWebInIPhone"),
              buildTableRow(code: "isWebInIPad", value: "$isWebInIPad"),
              buildTableRow(code: "isWebInWeChat", value: "$isWebInWeChat"),
              buildTableRow(code: "isPhone", value: "$isPhone"),
              buildTableRow(code: "isMacOS", value: "$isMacOS"),
              buildTableRow(code: "isIPhoneX", value: "$isIPhoneX"),
              buildTableRowTop(code: "adapt", value: "value"),
              buildTableRow(code: "adaptDp(1)", value: "${adaptDp(1)}"),
              buildTableRow(code: "adaptPx(2)", value: "${adaptPx(2)}"),
              buildTableRow(code: "adaptOnePx()", value: "${adaptOnePx()}"),
              buildTableRow(code: "screenWidthDp", value: "$screenWidthDp"),
              buildTableRow(code: "screenHeightDp", value: "$screenHeightDp"),
              buildTableRow(
                  code: "screenStatusBarHeightDp",
                  value: "$screenStatusBarHeightDp"),
              buildTableRow(
                  code: "screenToolbarHeightDp",
                  value: "$screenToolbarHeightDp"),
              buildTableRow(
                  code: "screenBottomBarHeightDp",
                  value: "$screenBottomBarHeightDp"),
              buildTableRowTop(code: "valid", value: "value"),
              buildTableRow(
                  code: "validIsPhone(\"13012345678\")",
                  value: "${validIsPhone("13012345678")}"),
              buildTableRowTop(code: "other", value: "value"),
              buildTableRow(code: "webUserAgent", value: "$webUserAgent"),
              buildTableRow(code: "randomInt(100)", value: '${randomInt(100)}'),
              buildTableRow(
                  code: "canLaunch(\"https://www.baidu.com\")",
                  value: '${canLaunch("https://www.baidu.com")}'),
              buildTableRow(
                  code: "onLaunch(\"https://www.baidu.com\")", value: ""),
              buildTableRow(
                  code: "setClipboard(\"https://www.baidu.com\")", value: ''),
              buildTableRow(code: "getClipboard()", value: "${getClipboard()}"),
              buildTableRow(
                  code: "assetsImagesPath(\"button\")",
                  value: "${assetsImagesPath("button")}"),
              buildTableRow(
                  code: "assetsImagesPathWebP(\"button\")",
                  value: "${assetsImagesPathWebP("button")}"),
              buildTableRow(
                  code: "appStoreUrl(\"1234567890\")",
                  value: "${appStoreUrl("1234567890")}"),
              buildTableRow(
                  code: "appStoreUserReviewsUrl(\"1234567890\")",
                  value: "${appStoreUserReviewsUrl("1234567890")}"),
            ],
          ),
          // buildTableRowTop(code: "log", value: "output"),
          SizedBox(height: 15),
          buildTableColumn(code: "logVerbose(\"Verbose log\")", value: """
flutter: ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
flutter: │ #0   main (package:flutter_easy_example/main.dart:12:10)
flutter: │ #1   _runMainZoned.<anonymous closure>.<anonymous closure> (dart:ui/hooks.dart:241:25)
flutter: ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
flutter: │ 10:58:12.126 (+0:00:00.012777)
flutter: ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
flutter: │ Verbose log
flutter: └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
                """),
          buildTableColumn(code: "logDebug(\"Debug log\")", value: """
flutter: ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
flutter: │ #0   main (package:flutter_easy_example/main.dart:12:10)
flutter: │ #1   _runMainZoned.<anonymous closure>.<anonymous closure> (dart:ui/hooks.dart:241:25)
flutter: ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
flutter: │ 10:58:12.126 (+0:00:00.012777)
flutter: ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
flutter: │ 🐛 Debug log
flutter: └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
                """),
          buildTableColumn(code: "logInfo(\"Info log\")", value: """
flutter: ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
flutter: │ #0   main (package:flutter_easy_example/main.dart:12:10)
flutter: │ #1   _runMainZoned.<anonymous closure>.<anonymous closure> (dart:ui/hooks.dart:241:25)
flutter: ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
flutter: │ 10:58:12.126 (+0:00:00.012777)
flutter: ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
flutter: │ 💡 Info log
flutter: └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
                """),
          buildTableColumn(code: "logWarning(\"Warning log\")", value: """
flutter: ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
flutter: │ #0   main (package:flutter_easy_example/main.dart:12:10)
flutter: │ #1   _runMainZoned.<anonymous closure>.<anonymous closure> (dart:ui/hooks.dart:241:25)
flutter: ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
flutter: │ 10:58:12.126 (+0:00:00.012777)
flutter: ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
flutter: │ ⚠️ Warning log
flutter: └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
                """),
          buildTableColumn(code: "logError(\"Error log\")", value: """
flutter: ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
flutter: │ #0   main (package:flutter_easy_example/main.dart:12:10)
flutter: │ #1   _runMainZoned.<anonymous closure>.<anonymous closure> (dart:ui/hooks.dart:241:25)
flutter: ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
flutter: │ 10:58:12.126 (+0:00:00.012777)
flutter: ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
flutter: │ ⛔ Error log
flutter: └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
                """),
          buildTableColumn(
              code: "logWTF(\"What a terrible failure log\")", value: """
flutter: ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
flutter: │ #0   main (package:flutter_easy_example/main.dart:12:10)
flutter: │ #1   _runMainZoned.<anonymous closure>.<anonymous closure> (dart:ui/hooks.dart:241:25)
flutter: ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
flutter: │ 10:58:12.126 (+0:00:00.012777)
flutter: ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
flutter: │ 👾 What a terrible failure log
flutter: └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
                """),
          FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: state.animationController,
                curve: Interval(0.2, 1, curve: Curves.ease),
              ),
            ),
            child: BaseButton(child: BaseText("Powered by OctMon"), onPressed: () {
              onLaunch("https://octmon.github.io");
            },),
          ),
        ],
      ),
    ),
  );
}
