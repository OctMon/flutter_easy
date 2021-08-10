import 'package:flutter/material.dart';
import 'package:flutter_easy_example/modules/root/controller.dart';
import 'package:flutter_easy_example/utils/user/service.dart';
import 'package:get/get.dart';
import 'package:flutter_easy_example/routes.dart';
import 'package:intl/intl.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/components/global/global_list_cell.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_easy_example/generated/l10n.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final service = Get.find<UserService>();
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          Obx(() {
            return BaseSliverAppBar(
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
                        onTap: service.isLogin ? null : () => toLogin(),
                        child: FlutterLogo(
                          size: adaptDp(80),
                          style: FlutterLogoStyle.markOnly,
                        ),
                      ),
                      GestureDetector(
                        onTap: service.isLogin ? null : () => toLogin(),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 18),
                          child: BaseText(
                            service.isLogin
                                ? (service.user?.value?.nickname)
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
              actions: service.isLogin
                  ? [
                      BaseButton(
                        child: Icon(
                          Icons.exit_to_app,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          showLoading();
                          await service.clean();
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
                                onLocaleChange(e);
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
                                    back();
                                    onLocaleChange(null);
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
