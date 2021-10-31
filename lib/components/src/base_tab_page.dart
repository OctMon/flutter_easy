import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

/*
final tabs = ["a", "b", "c"];

BaseTabPage(
        indicator: const BoxDecoration(image: indicatorImage),
        tabs: tabs
            .map((e) => Tab(
                  child: Text(e, style: TextStyle(fontSize: adaptDp(18))),
                ))
            .toList(),
        children: tabs.map((e) => Center(child: Text(e))).toList(),
      ),
 */
class BaseTabPage extends StatefulWidget {
  final double? tabBarHeight;
  final int initialIndex;
  final bool isScrollable;
  final Decoration? indicator;
  final Color? indicatorColor;
  final TabBarIndicatorSize? indicatorSize;
  final EdgeInsetsGeometry? labelPadding;
  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final ScrollPhysics? physics;
  final Widget divider;
  final List<Widget> tabs;
  final List<Widget> children;
  final Color backgroundColor;
  final Color? labelColor;
  final Color? unselectedLabelColor;

  const BaseTabPage({
    Key? key,
    this.tabBarHeight,
    this.initialIndex = 0,
    this.isScrollable = false,
    this.indicator,
    this.indicatorColor,
    this.indicatorSize,
    this.labelPadding,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.physics,
    this.divider = const Divider(height: 1),
    required this.tabs,
    required this.children,
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
            height: widget.tabBarHeight,
            color: widget.backgroundColor,
            child: TabBar(
              indicator: widget.indicator,
              isScrollable: widget.isScrollable,
              indicatorColor:
                  widget.indicatorColor ?? appTheme(context).primaryColor,
              indicatorSize:
                  widget.indicatorSize ?? TabBarTheme.of(context).indicatorSize,
              labelPadding: widget.labelPadding,
              labelColor: widget.labelColor ?? appTheme(context).primaryColor,
              labelStyle: widget.labelStyle,
              unselectedLabelStyle: widget.unselectedLabelStyle,
              unselectedLabelColor:
                  widget.unselectedLabelColor ?? colorWithHex3,
              tabs: widget.tabs,
            ),
          ),
          // Container(height: 5),
          widget.divider,
          Expanded(
            child: TabBarView(
              physics: widget.physics,
              children: widget.children,
            ),
          ),
        ],
      ),
    );
  }
}
