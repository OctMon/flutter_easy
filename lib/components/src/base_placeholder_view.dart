import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

/// 网络错误的占位图
var kPlaceholderImageRemote = assetsImagesPath("placeholder_remote");

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
        child: Container(
          height: 150,
          child: Column(
            children: <Widget>[
              Image.asset(
                placeholderImagePath,
                width: 100,
                height: 100,
              ),
              SizedBox(height: 15),
              Text(
                title ?? "",
                style: TextStyle(
                  color: appTheme(context).progressIndicatorTheme.color,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
