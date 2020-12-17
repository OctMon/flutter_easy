import 'package:flutter/material.dart';

Widget keepAliveWrapper(Widget child) => _KeepAlive(child: child);

class _KeepAlive extends StatefulWidget {
  final Widget child;

  const _KeepAlive({Key key, this.child}) : super(key: key);

  @override
  _KeepAliveState createState() => _KeepAliveState();
}

class _KeepAliveState extends State<_KeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
