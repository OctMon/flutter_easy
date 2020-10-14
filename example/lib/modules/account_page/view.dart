import 'package:flutter/material.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/components/global/global_list_cell.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_easy_example/generated/l10n.dart';

import 'action.dart';
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
                        state.user != null
                            ? (state.user.nickname)
                            : S.of(viewService.context).login,
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
            GlobalListCell(
              item: BaseKeyValue(
                  key: S.of(viewService.context).language,
                  value: "${S.of(viewService.context).systemDefault}",
                  extend: Icons.language),
              onPressed: () {
                showBaseModalBottomSheet(
                    context: viewService.context,
                    builder: (BuildContext context) {
                      return BaseActionSheet(
                        title: BaseText(S.of(viewService.context).language),
                        actions: S.delegate.supportedLocales.map((e) {
                          final localeString =
                              LocaleNames.of(context).nameOf(e.toString());
                          return BaseActionSheetAction(
                            onPressed: () {
                              pop(viewService.context);
                              dispatch(AccountActionCreator.onLocaleChange(e));
                            },
                            child: BaseText(localeString),
                          );
                        }).toList(),
                        cancelButton: BaseActionSheetAction(
                          child: BaseText('取消'),
                          isDestructiveAction: true,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      );
                    });
              },
            ),
          ]),
        ),
      ],
    ),
  );
}
