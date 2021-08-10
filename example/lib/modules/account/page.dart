import 'package:flutter/material.dart';
import 'package:flutter_easy_example/utils/user/controller.dart';
import 'package:get/get.dart';
import 'package:flutter_easy_example/routes.dart';
import 'package:intl/intl.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/components/global/global_list_cell.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_easy_example/generated/l10n.dart';

import 'controller.dart';

class AccountPage extends StatelessWidget {
  final AccountController controller = Get.put(AccountController());

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
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
                      onTap:
                          userController.user != null ? null : () => toLogin(),
                      child: FlutterLogo(
                        size: adaptDp(80),
                        style: FlutterLogoStyle.markOnly,
                      ),
                    ),
                    GestureDetector(
                      onTap:
                          userController.user != null ? null : () => toLogin(),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 18),
                        child: BaseText(
                          userController.user != null
                              ? (userController.user?.nickname)
                              : S.of(context).login,
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
            actions: userController.isLogin
                ? [
                    BaseButton(
                      child: Icon(Icons.exit_to_app),
                      onPressed: () async {
                        await userController.clean();
                        offAllNamed(Routes.root);
                      },
                    ),
                  ]
                : null,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              GlobalListCell(
                item: BaseKeyValue(
                    key: S.of(context).language,
                    value:
                        "${lastLocale == null ? S.of(context).systemDefault : LocaleNames.of(context)?.nameOf("$lastLocale")} - ${Intl.getCurrentLocale()}",
                    extend: Icons.language),
                onPressed: () {
                  showBaseModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return BaseActionSheet(
                          title: BaseText(S.of(context).language),
                          actions: S.delegate.supportedLocales.map((e) {
                            final String localeString =
                                LocaleNames.of(context)?.nameOf(e.toString());
                            final String nativeLocaleName =
                                LocaleNamesLocalizationsDelegate
                                    .nativeLocaleNames[e.toString()];
                            return BaseActionSheetAction(
                              onPressed: () {
                                back();
                                // dispatch(AccountActionCreator.onLocaleChange(e));
                              },
                              child: BaseText(nativeLocaleName == localeString
                                  ? nativeLocaleName
                                  : "$nativeLocaleName - $localeString"),
                            );
                          }).toList()
                            ..insert(
                                0,
                                BaseActionSheetAction(
                                  isDefaultAction: true,
                                  onPressed: () {
                                    back(); // dispatch(AccountActionCreator.onLocaleChange(
                                    //     null));
                                    Get.forceAppUpdate();
                                  },
                                  child: BaseText(S.of(context).systemDefault),
                                )),
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
}
