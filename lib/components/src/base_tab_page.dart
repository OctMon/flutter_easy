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
  final int initialIndex;
  final bool isScrollable;
  final Decoration? indicator;
  final Color? indicatorColor;
  final TabBarIndicatorSize? indicatorSize;
  final TextStyle labelStyle;
  final Widget divider;
  final List<Widget> tabs;
  final List<Widget> children;
  final Color backgroundColor;
  final Color? labelColor;
  final Color? unselectedLabelColor;

  const BaseTabPage({
    Key? key,
    this.initialIndex = 0,
    this.isScrollable = false,
    this.indicator,
    this.indicatorColor,
    this.indicatorSize,
    this.labelStyle = const TextStyle(fontWeight: FontWeight.normal),
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
            color: widget.backgroundColor,
            child: TabBar(
              indicator: widget.indicator,
              isScrollable: widget.isScrollable,
              indicatorColor:
                  widget.indicatorColor ?? appTheme(context).primaryColor,
              indicatorSize:
                  widget.indicatorSize ?? TabBarTheme.of(context).indicatorSize,
              labelPadding: EdgeInsets.symmetric(horizontal: 6),
              labelColor: widget.labelColor ?? appTheme(context).primaryColor,
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
