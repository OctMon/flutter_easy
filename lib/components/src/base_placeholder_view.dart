import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

/// 网络错误的占位图
String? kPlaceholderImageRemote;
String? kPlaceholderImageEmpty;

/// 占位图默认宽高
double kPlaceholderImageWidth = 180.adaptRatio;
double kPlaceholderImageBottom = 30;

class BasePlaceholderView extends StatelessWidget {
  final String? title;
  final String? image;
  final VoidCallback? onTap;

  const BasePlaceholderView({
    super.key,
    this.title = '暂无数据',
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
    if (title == kPlaceholderTitleRemote) {
      placeholderImagePath = kPlaceholderImageRemote;
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
              Text(
                title ?? "",
                style: appDarkMode(context)
                    ? setDarkPlaceholderTextStyle
                    : setLightPlaceholderTextStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
