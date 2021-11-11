import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

/// 网络错误的占位图
var kPlaceholderImageRemote = assetsImagesPath("placeholder_remote");

/// 占位图默认宽高
double kPlaceholderImageWidth = 180.adaptRatio;

class BasePlaceholderView extends StatelessWidget {
  final String? title;
  final String? image;
  final VoidCallback? onTap;

  const BasePlaceholderView({
    Key? key,
    this.title = '暂无数据',
    this.image,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (title == null || title?.isEmpty == true) {
      return Center(
        child: BaseLoadingView(),
      );
    }
    var placeholderImagePath = image ?? assetsImagesPath("placeholder_empty");
    switch (title) {
      case kPlaceholderTitleRemote:
        placeholderImagePath = kPlaceholderImageRemote;
        break;
    }
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                placeholderImagePath,
                width: kPlaceholderImageWidth,
              ),
              SizedBox(height: 30),
              Text(
                title ?? "",
                style: appDarkMode(context)
                    ? setDarkPlaceholderTextStyle
                    : setLightPlaceholderTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
