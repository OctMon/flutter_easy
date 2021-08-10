import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

class GlobalListCell extends StatelessWidget {
  final BaseKeyValue item;
  final VoidCallback? onPressed;

  const GlobalListCell({Key? key, required this.item, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        BaseInkWell(
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 15),
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: adaptDp(22),
                        child: Icon(item.extend, color: colorWithHex3),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Flexible(
                        child: BaseTitle(
                          item.key,
                          fontSize: adaptDp(16),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: onPressed != null,
                  child: Row(
                    children: [
                      BaseTitle(
                        item.value,
                        fontSize: adaptDp(14),
                      ),
                      Icon(Icons.navigate_next),
                    ],
                  ),
                )
              ],
            ),
          ),
          onPressed: onPressed,
        ),
        BaseDivider(),
      ],
    );
  }
}
