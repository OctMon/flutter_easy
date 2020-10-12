import 'package:flutter/material.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_easy/flutter_easy.dart';

//import 'action.dart';
import 'state.dart';

Widget buildView(
    AccountState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    body: CustomScrollView(
      slivers: <Widget>[
        BaseSliverAppBar(
          pinned: true,
          expandedHeight: 211.0 + (isIPhoneX ? 0 : 24),
          tintColor: Colors.white,
          backgroundColor: colorWithTint,
          brightness: Brightness.dark,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              margin: EdgeInsets.only(top: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: state.user != null
                        ? null
                        : () => pushNamedToLogin(viewService.context),
                    child: FlutterLogo(
                      size: adaptDp(80),
                      style: FlutterLogoStyle.markOnly,
                    ),
                  ),
                  GestureDetector(
                    onTap: state.user != null
                        ? null
                        : () => pushNamedToLogin(viewService.context),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 18),
                      child: BaseText(
                        state.user != null ? (state.user.nickname) : "登录",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: adaptDp(20),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            _SettingCell(
              item: BaseKeyValue(
                  key: "语言", value: 'System default', extend: Icons.language),
              onPressed: () {},
            ),
          ]),
        ),
      ],
    ),
  );
}

class _SettingCell extends StatelessWidget {
  final BaseKeyValue item;
  final VoidCallback onPressed;

  const _SettingCell({Key key, @required this.item, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        BaseInkWell(
          // color: Colors.white,
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 15),
            height: 44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: <Widget>[
                    Container(
                      width: adaptDp(22),
                      child: Icon(item.extend),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    BaseTitle(
                      item.key,
                      fontSize: adaptDp(18),
                    ),
                  ],
                ),
                Row(
                  children: [
                    BaseTitle(
                      item.value,
                      fontSize: adaptDp(18),
                    ),
                    Icon(Icons.navigate_next, color: Color(0xFFCCCCCC)),
                  ],
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
