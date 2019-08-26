import 'package:flutter/material.dart';

import '../utils/distance_utils.dart';
import '../utils/font_utils.dart';

class LoadingView extends StatelessWidget {
  final String message;

  const LoadingView({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.all((message == null) ? distanceWith30 : distanceWith15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }

  List<Widget> _buildChildren() {
    List<Widget> list = [CircularProgressIndicator()];
    if (message != null && message.isNotEmpty) {
      list.add(Padding(
        padding: const EdgeInsets.only(top: distanceWith8),
        child: Text(
          message,
          maxLines: 2,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontAutoSize(10),
          ),
        ),
      ));
    }
    return list;
  }
}
