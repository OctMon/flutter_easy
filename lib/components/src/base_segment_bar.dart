import 'package:flutter/material.dart';
import 'package:flutter_easy/utils/src/color_util.dart';

class BaseSegmentBar extends StatefulWidget {
  /// 所有按钮名字
  final List<String> titleNames;

  /// 默认颜色
  final Color defaultColor;

  /// 选中时的颜色
  final Color? selectedColor;

  /// 字体大小
  final double textSize;

  /// 默认选中的下标
  final int selectIndex;

  /// 点击回调
  final Function(int) onSelectChanged;

  /// 按钮高度
  final double itemHeight;

  /// 按钮宽度
  final double itemWidth;

  /// 按钮边框宽度
  final double borderWidth;

  /// 按钮边框颜色
  final Color? borderColor;

  /// 按钮圆角角度大小
  final double radius;

  /// 按钮的外边距
  final EdgeInsetsGeometry margin;

  BaseSegmentBar(
      {required this.titleNames,
      required this.onSelectChanged,
      this.defaultColor = Colors.white,
      this.selectedColor,
      this.textSize = 14,
      this.itemHeight = 30,
      this.itemWidth = 110,
      this.borderWidth = 1,
      this.borderColor,
      this.radius = 5,
      this.selectIndex = 0,
      this.margin = const EdgeInsets.only(top: 5, bottom: 5)});

  @override
  _BaseSegmentBarState createState() => _BaseSegmentBarState();
}

class _BaseSegmentBarState extends State<BaseSegmentBar> {
  late int selectItem;
  late Color selectedColor;
  late Color borderColor;

  @override
  void initState() {
    selectItem = widget.selectIndex;
    selectedColor = widget.selectedColor ?? appTheme(context).primaryColor;
    borderColor = widget.borderColor ?? appTheme(context).primaryColor;
    super.initState();
  }

  buildSegmentItems(List list) {
    if (list.isEmpty) {
      return Container();
    }
    List<Widget> items = [];
    for (var i = 0; i < list.length; i++) {
      Widget item = Container(
        margin: widget.margin,
        child: buildSegmentItem(list[i], i),
      );
      items.add(item);
    }

    return items;
  }

  buildSegmentItem(String title, int index) {
    buildShape() {
      return MaterialStateProperty.all(widget.margin.horizontal > 0
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.radius))
          : index == 0
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(widget.radius),
                      bottomLeft: Radius.circular(widget.radius)))
              : index == widget.titleNames.length - 1
                  ? RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(widget.radius),
                          bottomRight: Radius.circular(widget.radius)))
                  : RoundedRectangleBorder());
    }

    return Container(
      // 保持按钮高度选中不选中一样
      height: widget.itemHeight,
      width: widget.itemWidth,
      child: (widget.margin.horizontal > 0
              ? selectItem != index
              : selectItem == index)
          ? TextButton(
              onPressed: () {
                updateItem(index);
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                shape: buildShape(),
                backgroundColor: MaterialStateProperty.all(
                    selectItem == index ? selectedColor : widget.defaultColor),
                splashFactory: NoSplash.splashFactory,
              ),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: widget.textSize,
                  color: selectItem == index
                      ? widget.defaultColor
                      : (widget.margin.horizontal > 0
                          ? colorWithHex3
                          : selectedColor),
                ),
              ),
            )
          : OutlinedButton(
              onPressed: () {
                updateItem(index);
              },
              style: ButtonStyle(
                shape: buildShape(),
                side: MaterialStateProperty.all(
                    BorderSide(color: borderColor, width: widget.borderWidth)),
                backgroundColor: MaterialStateProperty.all(
                    selectItem == index ? selectedColor : widget.defaultColor),
                splashFactory: NoSplash.splashFactory,
              ),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: widget.textSize,
                  color: selectItem == index
                      ? (widget.margin.horizontal > 0
                          ? borderColor
                          : widget.defaultColor)
                      : selectedColor,
                ),
              ),
            ),
    );
  }

  /// 点击修改视图样式，回调点击的方法
  updateItem(int selectedPosition) {
    if (selectedPosition == selectItem) {
      return;
    } else {
      selectItem = selectedPosition;
      widget.onSelectChanged(selectedPosition);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buildSegmentItems(widget.titleNames),
    );
  }
}
