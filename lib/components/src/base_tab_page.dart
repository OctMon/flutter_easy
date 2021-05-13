import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

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
  final Color? indicatorColor;
  final TextStyle labelStyle;
  final List<Widget> tabs;
  final List<Widget> children;

  const BaseTabPage(
      {Key? key,
      this.initialIndex = 0,
      this.isScrollable = false,
      this.indicatorColor,
      this.labelStyle = const TextStyle(fontWeight: FontWeight.normal),
      required this.tabs,
      required this.children})
      : super(key: key);

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
            color: Colors.white,
            child: TabBar(
              isScrollable: widget.isScrollable,
              indicatorColor: widget.indicatorColor ?? colorWithTint,
              indicatorSize: TabBarIndicatorSize.label,
              labelPadding: EdgeInsets.symmetric(horizontal: 6),
              labelColor: colorWithTint,
              labelStyle: widget.labelStyle,
              unselectedLabelColor: colorWithHex3,
              tabs: widget.tabs,
            ),
          ),
          // Container(height: 5),
          Divider(
            height: 1,
          ),
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
