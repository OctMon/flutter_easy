import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/utils/change_theme.dart';

import 'controller.dart';
import 'state.dart';

class HomePage extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  final HomeState state = Get.find<HomeController>().state;

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    TableRow buildTableRow({required String code, required String value}) {
      return TableRow(
        children: [
          Center(
              child: Container(
                  margin: const EdgeInsets.all(5), child: Text(code))),
          Center(
              child: Container(
                  margin: const EdgeInsets.all(5), child: Text(value))),
        ],
      );
    }

    TableRow buildTableRowTop({required String code, required String value}) {
      return TableRow(
        //第一行样式 添加背景色
        decoration: BoxDecoration(
          color: appTheme(context).primaryColor,
        ),
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.all(5),
              child: Text(
                code,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    }

    return BaseScaffold(
      appBar: BaseAppBar(
        leading: isAppDebugFlag
            ? IconButton(
                icon: const Icon(Icons.developer_mode),
                onPressed: () {
                  showSelectBaseURLTypeAlert(context: context);
                },
              )
            : null,
        title: Obx(() {
          return GestureDetector(
            child: Text(
              appName,
              style: appTheme(context)
                  .appBarTheme
                  .titleTextStyle
                  ?.copyWith(color: controller.color.value),
            ),
            onTap: () {
              showChangeThemeDialog(context);
            },
          );
        }),
        actions: [
          BaseButton(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: const Icon(Icons.volunteer_activism),
              onPressed: () {
                showChangeColorDialog(context, controller.color.value,
                    completion: (Color value) {
                  controller.color.value = value;
                  showNotificationToast("颜色已修改为${controller.color.value}");
                });
              }),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: const Text('OctMon'),
              accountEmail: const Text('octmon@qq.com'),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.home),
              ),
              onDetailsPressed: () {},
              otherAccountsPictures: const <Widget>[
                CircleAvatar(child: Icon(Icons.settings)),
              ],
              decoration: const BoxDecoration(color: Colors.green),
            ),
            const ListTile(
              title: Text('设置'),
              leading: Icon(Icons.settings),
              trailing: Icon(Icons.arrow_forward_ios),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: <Widget>[
            BaseWebImage(
              "https://p3.qhimg.com/t01fad0023a8d68490d.jpg",
              height: min(screenWidthDp, screenHeightDp * 0.5),
              fit: BoxFit.cover,
              imageCompletionHandler: (info) {
                logDebug(info);
              },
            ),
            Obx(() {
              return Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const {
                  // 0: FixedColumnWidth(adaptDp(130)),
                },
                border: TableBorder.all(
                  color: appTheme(context).primaryColor,
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
                      code: "appInstallerStore", value: "$appInstallerStore"),
                  buildTableRow(code: "installTime", value: "$appInstallTime"),
                  buildTableRow(code: "appUpdateTime", value: "$appUpdateTime"),
                  buildTableRow(code: "appLocale", value: "$appLocale"),
                  buildTableRow(
                      code: "appDeviceLocale", value: "$appDeviceLocale"),
                  buildTableRow(code: "appChannel", value: appChannel),
                  buildTableRow(
                      code: "appIsDarkMode", value: "${appDarkMode(context)}"),
                  buildTableRow(
                      code: "appTheme.primaryColor",
                      value: "${appTheme(context).primaryColor}"),
                  buildTableRow(
                    code: "translationAsset",
                    value:
                        assetsImagesPath("placeholder_empty").translationAsset,
                  ),
                  buildTableRow(
                      code: "timestampToNormal_yyyy_MM_dd_HH_mm_ss",
                      value: timestampToNormal_yyyy_MM_dd_HH_mm_ss(
                          timestampNow())),
                  buildTableRow(
                    code: "2小时前的消息",
                    value: DateTime.now()
                        .subtract(Duration(hours: 2))
                        .toChatTimeFormat(),
                  ),
                  buildTableRow(
                    code: "昨天的消息",
                    value: DateTime.now()
                        .subtract(Duration(days: 1))
                        .toChatTimeFormat(),
                  ),
                  buildTableRow(
                    code: "本周内的消息",
                    value: DateTime.now()
                        .subtract(Duration(days: 3))
                        .toChatTimeFormat(),
                  ),
                  buildTableRow(
                    code: "超过一周的消息",
                    value: DateTime.now()
                        .subtract(Duration(days: 100))
                        .toChatTimeFormat(),
                  ),
                  buildTableRow(
                    code: "超过一年的消息",
                    value: DateTime.now()
                        .subtract(Duration(days: 400))
                        .toChatTimeFormat(),
                  ),
                  buildTableRowTop(code: "device", value: "value"),
                  buildTableRow(code: "deviceModel", value: deviceModel),
                  buildTableRow(code: "deviceBrand", value: deviceBrand),
                  buildTableRow(code: "deviceName", value: deviceName),
                  buildTableRow(
                      code: "deviceSystemVersion", value: deviceSystemVersion),
                  buildTableRow(
                      code: "deviceIsPhysicalDevice",
                      value: "$deviceIsPhysicalDevice"),
                  buildTableRowTop(code: "is", value: "value"),
                  buildTableRow(code: "isProduction", value: "$isProduction"),
                  buildTableRow(code: "isDebug", value: "$isDebug"),
                  buildTableRow(
                      code: "isAppDebugFlag", value: "$isAppDebugFlag"),
                  buildTableRow(code: "isAndroid", value: "$isAndroid"),
                  buildTableRow(code: "isIOS", value: "$isIOS"),
                  buildTableRow(code: "isIPad", value: "$isIPad"),
                  buildTableRow(code: "userAgent", value: userAgent),
                  buildTableRow(code: "isWeb", value: "$isWeb"),
                  buildTableRow(
                      code: "isWebInAndroid", value: "$isWebInAndroid"),
                  buildTableRow(code: "isWebInIos", value: "$isWebInIos"),
                  buildTableRow(code: "isWebInIPhone", value: "$isWebInIPhone"),
                  buildTableRow(code: "isWebInIPad", value: "$isWebInIPad"),
                  buildTableRow(code: "isWebInMobile", value: "$isWebInMobile"),
                  buildTableRow(code: "isWebInWeChat", value: "$isWebInWeChat"),
                  buildTableRow(code: "isPhone", value: "$isPhone"),
                  buildTableRow(code: "isMacOS", value: "$isMacOS"),
                  buildTableRow(code: "isIPhoneX", value: "$isIPhoneX"),
                  buildTableRowTop(code: "adapt", value: "value"),
                  buildTableRow(code: "adaptDp(1)", value: "${adaptDp(1)}"),
                  buildTableRow(
                      code: "100.adaptRatio", value: "${100.adaptRatio}"),
                  buildTableRow(code: "adaptPx(2)", value: "${adaptPx(2)}"),
                  buildTableRow(code: "adaptOnePx()", value: "${adaptOnePx()}"),
                  buildTableRow(code: "screenWidthDp", value: "$screenWidthDp"),
                  buildTableRow(
                      code: "screenHeightDp", value: "$screenHeightDp"),
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
                      code: "\"150102201203072197\".getAgeFromIdentityCard",
                      value: "${"150102201203072197".getAgeFromIdentityCard}"),
                  buildTableRow(
                      code: "\"110101193703074649\".getSexFromIdentityCard",
                      value: "110101193703074649".getSexFromIdentityCard),
                  buildTableRow(
                      code: "\"octmon#qq.com\".isEmail",
                      value: "${"octmon#qq.com".isEmail}"),
                  buildTableRow(
                      code: "\"\".isEmptyOrNull", value: "${"".isEmptyOrNull}"),
                  buildTableRow(code: "\"OctMon\".md5", value: "OctMon".md5),
                  buildTableRow(
                      code: "\"OctMon\".hmacSha256(key: \"test\")",
                      value: "OctMon".hmacSha256(key: "test")),
                  buildTableRow(
                      code: "\"OctMon\".hmacSha256",
                      value: "OctMon".hmacSha256ToBase64),
                  buildTableRowTop(code: "other", value: "value"),
                  buildTableRow(
                    code: "operatingSystemVersion",
                    value: operatingSystemVersion,
                  ),
                  buildTableRow(
                    code: "operatingSystem",
                    value: operatingSystem,
                  ),
                  buildTableRow(code: "webUserAgent", value: webUserAgent),
                  buildTableRow(
                      code: "randomInt(100)", value: '${randomInt(100)}'),
                  buildTableRow(
                      code: "canLaunch(\"https://www.baidu.com\")",
                      value: '${canLaunch("https://www.baidu.com")}'),
                  buildTableRow(
                      code: "onLaunch(\"https://www.baidu.com\")", value: ""),
                  buildTableRow(
                      code: "setClipboard(\"https://www.baidu.com\")",
                      value: ''),
                  buildTableRow(
                      code: "getClipboard()", value: state.clipboard.value),
                  buildTableRow(
                      code: "assetsImagesPath(\"button\")",
                      value: assetsImagesPath("button")),
                  buildTableRow(
                      code: "assetsImagesPathWebP(\"button\")",
                      value: assetsImagesPathWebP("button")),
                  buildTableRow(
                      code: "appStoreUrl(\"1234567890\")",
                      value: appStoreUrl("1234567890")),
                  buildTableRow(
                      code: "appStoreUserReviewsUrl(\"1234567890\")",
                      value: appStoreUserReviewsUrl("1234567890")),
                  if (controller.pathList.isNotEmpty) ...[
                    buildTableRowTop(code: "get", value: "value"),
                    ...controller.pathList
                        .map((e) => buildTableRow(code: e.key, value: e.value)),
                  ],
                ],
              );
            }),
            const SizedBox(height: 15),
            SizedBox(
              height: 44,
              child: BaseTextButton(
                borderRadius: BorderRadius.circular(6),
                child: const Text(
                  "BaseTextButton",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  showToast("status");
                  1.seconds.delay(() {
                    showSuccessToast("success");
                  });
                },
              ),
            ),
            const SizedBox(height: 15),
            BaseGradientButton(
              title: const Text(
                "BaseGradientButton",
                style: TextStyle(color: Colors.white),
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
                  curve: const Interval(0.2, 1, curve: Curves.ease),
                ),
              ),
              child: BaseButton(
                child: const Text("Powered by OctMon"),
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
