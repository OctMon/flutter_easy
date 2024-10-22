import 'package:flutter/material.dart';

import 'package:flutter_easy/flutter_easy.dart';

class BaseLoadingView extends StatelessWidget {
  final String? message;

  const BaseLoadingView({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    if (baseDefaultAnimationImage != null) {
      return message?.isNotEmpty == true
          ? Stack(
              alignment: Alignment.bottomCenter,
              fit: StackFit.expand,
              children: <Widget>[
                baseDefaultAnimationImage!,
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(top: 100),
                    child: Text(
                      message ?? "",
                    ),
                  ),
                ),
              ],
            )
          : baseDefaultAnimationImage!;
    }
    return Padding(
      padding: EdgeInsets.all((message == null) ? 0 : 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }

  List<Widget> _buildChildren() {
    List<Widget> list = [CircularProgressIndicator.adaptive()];
    if (message != null && message!.isNotEmpty) {
      list.add(Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Text(
          message ?? "",
          maxLines: 2,
          style: TextStyle(
            color: colorWithHex9,
            fontSize: 14,
          ),
        ),
      ));
    }
    return list;
  }
}
