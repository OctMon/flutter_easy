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
            margin: const EdgeInsets.only(left: 20, right: 15),
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: adaptDp(22),
                        child: Icon(item.extend),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Flexible(
                        child: BaseText(
                          item.key,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: onPressed != null,
                  child: Row(
                    children: [
                      BaseText(item.value),
                      const Icon(Icons.navigate_next),
                    ],
                  ),
                )
              ],
            ),
          ),
          onPressed: onPressed,
        ),
        const BaseDivider(),
      ],
    );
  }
}
