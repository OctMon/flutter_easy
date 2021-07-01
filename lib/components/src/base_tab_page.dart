import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

mixin BaseTabState<T> {
  int get initIndex;

  set initIndex(int initIndex);

  updateInitIndex(Map<String, dynamic> args) {
    int index = 0;
    if (args != null) {
      index = args['index'] ?? 0;
    }
    initIndex = index;
  }
}

/*
BaseScaffold(
  appBar: BaseAppBar(
    title: BaseText("标题"),
  ),
  body: BaseTabPage(
    initialIndex: state.initialIndex,
    tabs: ["a", "b", "c"]
        .map(
          (e) => Tab(
            child: BaseText(
              e,
              style: TextStyle(fontSize: adaptDp(18)),
            ),
          ),
        )
        .toList(),
    children: ["a", "b", "c"]
        .map(
          (e) => keepAliveClientWrapper(Center(child: BaseText(e))),
        )
        .toList(),
  )
 */
class BaseTabPage extends StatefulWidget {
  final int initialIndex;
  final bool isScrollable;
  final Color indicatorColor;
  final TextStyle labelStyle;
  final Widget divider;
  final List<Widget> tabs;
  final List<Widget> children;
  final Color backgroundColor;
  final Color labelColor;
  final Color unselectedLabelColor;

  const BaseTabPage({
    Key key,
    this.initialIndex = 0,
    this.isScrollable = false,
    this.indicatorColor,
    this.labelStyle = const TextStyle(fontWeight: FontWeight.normal),
    this.divider = const Divider(height: 1),
    this.tabs,
    this.children,
    this.backgroundColor = Colors.white,
    this.labelColor,
    this.unselectedLabelColor,
  }) : super(key: key);

  @override
  _BaseTabPageState createState() => _BaseTabPageState();
}

class _BaseTabPageState extends State<BaseTabPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.tabs.length,
      initialIndex: widget.initialIndex,
      child: Column(
        children: <Widget>[
          Container(
            color: widget.backgroundColor,
            child: TabBar(
              isScrollable: widget.isScrollable,
              indicatorColor: widget.indicatorColor ?? colorWithTint,
              indicatorSize: TabBarIndicatorSize.label,
              labelPadding: EdgeInsets.symmetric(horizontal: 6),
              labelColor: widget.labelColor ?? colorWithTint,
              labelStyle: widget.labelStyle,
              unselectedLabelColor:
                  widget.unselectedLabelColor ?? colorWithHex3,
              tabs: widget.tabs,
            ),
          ),
          // Container(height: 5),
          widget.divider,
          Expanded(
            child: TabBarView(
              children: widget.children,
            ),
          ),
        ],
      ),
    );
  }
}
