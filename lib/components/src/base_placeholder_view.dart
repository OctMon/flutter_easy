import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

/// 网络错误的提示语
String? kPlaceholderTitleConnection = "网络连接出错，请检查网络连接";
String? kPlaceholderMessageConnection;

/// 服务器错误的提示语
String? kPlaceholderTitleBadResponse = "服务器错误，请稍后重试";
String? kPlaceholderMessageBadResponse;

/// 网络错误的占位图
Widget? kPlaceholderWidgetConnection;
Widget? kPlaceholderWidgetEmpty;

/// 重试按钮
Widget? kPlaceholderReloadButton;

/// 占位图默认宽高
double? kPlaceholderImageBottom = 8;
double? kPlaceholderTitleBottom = 8;

class BasePlaceholderView extends StatelessWidget {
  final String? title;
  final TextStyle? titleStyle;
  final String? message;
  final TextStyle? messageStyle;
  final Widget? image;
  final VoidCallback? onTap;

  const BasePlaceholderView({
    super.key,
    this.title,
    this.titleStyle,
    this.message,
    this.messageStyle,
    this.image,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (title == null || title?.isEmpty == true) {
      return Center(
        child: BaseLoadingView(),
      );
    }
    var placeholderWidget = image ?? kPlaceholderWidgetEmpty;
    if (title == kPlaceholderTitleConnection ||
        title == kPlaceholderTitleBadResponse) {
      placeholderWidget = kPlaceholderWidgetConnection;
    }
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (placeholderWidget != null)
                Padding(
                  padding:
                      EdgeInsets.only(bottom: kPlaceholderImageBottom ?? 0),
                  child: placeholderWidget,
                ),
              if (title != null)
                Text(
                  title ?? "",
                  style: titleStyle ??
                      (appDarkMode(context)
                          ? setDarkPlaceholderTitleTextStyle
                          : setLightPlaceholderTitleTextStyle),
                  textAlign: TextAlign.center,
                ),
              if (message != null && message != title)
                Text(
                  message ?? "",
                  style: messageStyle ??
                      (appDarkMode(context)
                          ? setDarkPlaceholderMessageTextStyle
                          : setLightPlaceholderMessageTextStyle),
                  textAlign: TextAlign.center,
                ).marginOnly(top: kPlaceholderTitleBottom ?? 0),
              if ((title == kPlaceholderTitleConnection ||
                      title == kPlaceholderTitleBadResponse) &&
                  kPlaceholderReloadButton != null)
                BaseButton(
                  padding: EdgeInsets.zero,
                  child: kPlaceholderReloadButton!,
                  onPressed: onTap,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
