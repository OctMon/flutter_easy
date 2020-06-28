import 'package:flutter/material.dart';

import 'web_image.dart';

Widget _baseDefaultLaunchLocalWidget =
    FlutterLogo(style: FlutterLogoStyle.horizontal);

Alignment baseDefaultLaunchLocalImageAlignment = Alignment.bottomCenter;

double baseDefaultLaunchLocalImageWidthScale = 0.55;
double baseDefaultLaunchLocalImagePadding = 0.1;

/// 本地启动图
/// child只需设置一次
class BaseLaunchLocal extends StatelessWidget {
  final Color color;
  final Widget child;

  const BaseLaunchLocal({Key key, this.color = Colors.white, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (child != null) {
      _baseDefaultLaunchLocalWidget = child;
    }
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          alignment: baseDefaultLaunchLocalImageAlignment,
          padding: EdgeInsets.only(
              top: baseDefaultLaunchLocalImageAlignment == Alignment.topCenter
                  ? constraints.maxHeight * baseDefaultLaunchLocalImagePadding
                  : 0,
              bottom: baseDefaultLaunchLocalImageAlignment ==
                      Alignment.bottomCenter
                  ? constraints.maxHeight * baseDefaultLaunchLocalImagePadding
                  : 0),
          color: color,
          child: Container(
            width: constraints.maxWidth * baseDefaultLaunchLocalImageWidthScale,
            height: baseDefaultLaunchLocalImageWidthScale == 1 &&
                    baseDefaultLaunchLocalImagePadding == 0
                ? constraints.maxHeight
                : null,
            child: _baseDefaultLaunchLocalWidget,
          ),
        );
      },
    );
  }
}

/// 远程启动图
class BaseLaunchRemote extends StatelessWidget {
  final String url;
  final bool keepLogo;
  final VoidCallback onTap;

  const BaseLaunchRemote({Key key, this.url, this.keepLogo = true, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      WebImage(
        url ?? "",
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        placeholder: Container(),
        fit: BoxFit.fill,
      ),
      BaseLaunchLocal(color: Colors.transparent),
    ];
    if (!keepLogo) {
      children = children.reversed.toList();
    }
    return GestureDetector(
      onTap: onTap == null
          ? null
          : () {
              if (url != null && url.isNotEmpty) {
                onTap();
              }
            },
      child: Stack(
        children: children,
      ),
    );
  }
}
