import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

/// 网络错误的提示语
String? kPlaceholderTitleConnection = "网络连接出错，请检查网络连接";
String? kPlaceholderMessageConnection;

/// 服务器错误的提示语
String? kPlaceholderTitleBadResponse = "服务器错误，请稍后重试";
String? kPlaceholderMessageBadResponse;

/// 网络错误的占位图
String? kPlaceholderImageConnection;
String? kPlaceholderImageEmpty;

/// 重试按钮
Widget? kPlaceholderReloadButton;

/// 占位图默认宽高
double kPlaceholderImageWidth = 180.adaptRatio;
double kPlaceholderImageBottom = 8;
double kPlaceholderTitleBottom = 8;

class BasePlaceholderView extends StatelessWidget {
  final String? title;
  final String? message;
  final String? image;
  final VoidCallback? onTap;

  const BasePlaceholderView({
    super.key,
    this.title,
    this.message,
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
    var placeholderImagePath = image ?? kPlaceholderImageEmpty;
    if (title == kPlaceholderTitleConnection ||
        title == kPlaceholderTitleBadResponse) {
      placeholderImagePath = kPlaceholderImageConnection;
    }
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (placeholderImagePath != null)
                Padding(
                  padding: EdgeInsets.only(bottom: kPlaceholderImageBottom),
                  child: Image.asset(
                    placeholderImagePath,
                    width: kPlaceholderImageWidth,
                  ),
                ),
              if (title != null)
                Text(
                  title ?? "",
                  style: appDarkMode(context)
                      ? setDarkPlaceholderTitleTextStyle
                      : setLightPlaceholderTitleTextStyle,
                  textAlign: TextAlign.center,
                ),
              if (message != null && message != title)
                Text(
                  message ?? "",
                  style: appDarkMode(context)
                      ? setDarkPlaceholderMessageTextStyle
                      : setLightPlaceholderMessageTextStyle,
                  textAlign: TextAlign.center,
                ).marginOnly(top: kPlaceholderTitleBottom),
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
