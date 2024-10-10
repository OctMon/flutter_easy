import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

import '../../utils/src/global_util.dart';
import 'base.dart';

class BaseExampleWrap extends StatelessWidget {
  final String title;
  final List<BaseKeyValue> children;

  const BaseExampleWrap(
      {super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("$title:"),
        Flexible(
          child: Wrap(
            children: children
                .map(
                  (element) => BaseButton(
                    onPressed: element.extend,
                    child: Column(
                      children: [
                        Text(element.key),
                        Text(element.value),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class BaseExampleView extends StatelessWidget {
  final Widget child;
  final double top;
  final List<BaseExampleWrap> list;

  const BaseExampleView(
      {super.key, required this.child, this.top = 0, required this.list});

  @override
  Widget build(BuildContext context) {
    if (isDebug) {
      return Stack(
        children: [
          child,
          ListView(
            padding: EdgeInsets.all(10),
            children: list,
          ).marginOnly(
              top: screenStatusBarHeightDp + screenToolbarHeightDp + top),
        ],
      );
    }
    return child;
  }
}
