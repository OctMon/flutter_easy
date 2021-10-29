import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy_example/utils/user/service.dart';
import 'package:flutter_easy_example/routes.dart';
import 'package:intl/intl.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/components/global/global_list_cell.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_easy_example/generated/l10n.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          Obx(() {
            return BaseSliverAppBar(
              systemOverlayStyle: SystemUiOverlayStyle.light,
              pinned: true,
              expandedHeight: 211.0 + (isIPhoneX ? 0 : 24),
              tintColor: Colors.white,
              backgroundColor: appTheme(context).primaryColor,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: UserService.find.isLogin ? null : () => toLogin(),
                        child: FlutterLogo(
                          size: adaptDp(80),
                          style: FlutterLogoStyle.markOnly,
                        ),
                      ),
                      GestureDetector(
                        onTap: UserService.find.isLogin ? null : () => toLogin(),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 18),
                          child: Text(
                            UserService.find.isLogin
                                ? (UserService.find.user.value.nickname ?? "")
                                : S.of(context).login,
                            style: TextStyle(
                              fontSize: 30.adaptRatio,
                              fontWeight: FontWeight.w500,
                              color: appDarkMode(context)
                                  ? Colors.white
                                  : Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: UserService.find.isLogin
                  ? [
                      BaseButton(
                        child: const Icon(
                          Icons.exit_to_app,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          showLoading();
                          await UserService.find.clean();
                          dismissLoading();
                          offAllNamed(Routes.root);
                        },
                      ),
                    ]
                  : null,
            );
          }),
          SliverList(
            delegate: SliverChildListDelegate([
              GlobalListCell(
                item: BaseKeyValue(
                    key: S.of(context).language,
                    value:
                        "${appLocale == appDeviceLocale ? S.of(context).systemDefault : LocaleNames.of(context)?.nameOf("$appLocale")} - ${Intl.getCurrentLocale()}",
                    extend: Icons.language),
                onPressed: () {
                  showBaseModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return BaseActionSheet(
                          title: Text(S.of(context).language),
                          actions: S.delegate.supportedLocales.map((l) {
                            final String? localeString =
                                LocaleNames.of(context)?.nameOf(l.toString());
                            final String? nativeLocaleName =
                                LocaleNamesLocalizationsDelegate
                                    .nativeLocaleNames[l.toString()];
                            return BaseActionSheetAction(
                              onPressed: () {
                                offBack();
                                appUpdateLocale(l);
                              },
                              child: Text(nativeLocaleName == localeString
                                  ? (nativeLocaleName ?? "")
                                  : "$nativeLocaleName - $localeString"),
                            );
                          }).toList()
                            ..insert(
                                0,
                                BaseActionSheetAction(
                                  isDefaultAction: true,
                                  onPressed: () {
                                    offBack();
                                    if (appDeviceLocale != null) {
                                      appUpdateLocale(appDeviceLocale!);
                                    }
                                  },
                                  child: Text(S.of(context).systemDefault),
                                )),
                          cancelButton: BaseActionSheetAction(
                            child: const Text('取消'),
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
