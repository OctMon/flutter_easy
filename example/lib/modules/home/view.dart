import 'package:flutter/material.dart';
import 'package:get/get.dart' hide GetStringUtils, GetNumUtils, GetDurationUtils;
import 'package:flutter_easy/flutter_easy.dart';

import 'logic.dart';
import 'state.dart';

class HomePage extends StatelessWidget {
  final HomeLogic logic = Get.put(HomeLogic());
  final HomeState state = Get.find<HomeLogic>().state;

  @override
  Widget build(BuildContext context) {
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
        leading: isAppDebugFlag
            ? IconButton(
          icon: Icon(Icons.developer_mode),
          onPressed: () {
            showSelectBaseURLTypeAlert(context: context);
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
                buildTableRow(
                    code: "timestampToNormal_yyyy_MM_dd_HH_mm_ss",
                    value:
                    "${timestampToNormal_yyyy_MM_dd_HH_mm_ss(timestampNow())}"),
                buildTableRowTop(code: "is", value: "value"),
                buildTableRow(code: "isProduction", value: "$isProduction"),
                buildTableRow(code: "isDebug", value: "$isDebug"),
                buildTableRow(code: "isAppDebugFlag", value: "$isAppDebugFlag"),
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
                buildTableRow(code: "100.adaptRatio", value: "${100.adaptRatio}"),
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
                buildTableRowTop(code: "extensions", value: "value"),
                buildTableRow(
                    code: "\"13012345678\".isPhoneNumber",
                    value: "${"13012345678".isCNPhoneNumber}"),
                buildTableRow(
                    code: "\"110101199003071276\".isIdentityCard",
                    value: "${"110101199003071276".isIdentityCard}"),
                buildTableRow(
                    code: "\"150102201203072197\".isIdentityCard",
                    value: "${"150102201203072197".getAgeFromIdentityCard}"),
                buildTableRow(
                    code: "\"110101193703074649\".isIdentityCard",
                    value: "${"110101193703074649".getSexFromIdentityCard}"),
                buildTableRow(
                    code: "\"octmon#qq.com\".isEmail",
                    value: "${"octmon#qq.com".isEmail}"),
                buildTableRow(
                    code: "\"\".isEmptyOrNull", value: "${"".isEmptyOrNull}"),
                buildTableRow(code: "\"OctMon\".md5", value: "${"OctMon".md5}"),
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
            BaseBackgroundButton(
              title: BaseTitle(
                "BaseBackgroundButton",
                color: Colors.white,
              ),
              onPressed: () {
                showToast("status");
                1.seconds.delay(() {
                  showSuccessToast("success");
                });
              },
            ),
            SizedBox(height: 15),
            BaseGradientButton(
              title: BaseTitle(
                "BaseGradientButton",
                color: Colors.white,
              ),
              onPressed: () {
                showLoading();
                3.seconds.delay(() {
                  dismissLoading();
                });
              },
            ),
            FadeTransition(
              opacity: Tween(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: state.animationController,
                  curve: Interval(0.2, 1, curve: Curves.ease),
                ),
              ),
              child: BaseButton(
                child: BaseText("Powered by OctMon"),
                onPressed: () {
                  onLaunch("https://octmon.github.io");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
