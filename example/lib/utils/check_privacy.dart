import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/generated/l10n.dart';

import '../routes.dart';

Future<bool> checkPrivacy(BuildContext context) async {
  final kPrivacy = "checkPrivacy".md5;
  if (await getStorageBool(kPrivacy) == true) {
    return false;
  }
  return await showBaseDialog<bool>(
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: BaseAlertDialog(
              title: Text(
                "$appName${S.of(context).example_UserAgreement}${S.of(context).example_And}\n${S.of(context).example_PrivacyPolicy}",
                textAlign: TextAlign.center,
              ),
              titlePadding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 20.0),
              margin: const EdgeInsets.all(38.0),
              actionPadding: const EdgeInsets.only(top: 30),
              content: Column(
                children: <Widget>[
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontSize: adaptDp(14),
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                      children: [
                        TextSpan(
                          text: S.of(context).exampleCheckPrivacyAlertBegin,
                        ),
                        TextSpan(
                          text: S.of(context).example_UserAgreement,
                          style: TextStyle(
                            color: appTheme(context).primaryColor,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => toNamed(Routes.photosTab,
                                preventDuplicates: false),
                        ),
                        TextSpan(
                          text: S.of(context).example_And,
                        ),
                        TextSpan(
                          text: S.of(context).example_PrivacyPolicy,
                          style: TextStyle(
                            color: appTheme(context).primaryColor,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => toNamed(Routes.photosTab,
                                preventDuplicates: false),
                        ),
                        TextSpan(
                          text: S.of(context).exampleCheckPrivacyAlertEnd,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                Expanded(
                  child: BaseBackgroundButton(
                    borderRadius: 0,
                    title: Text(
                      S.of(context).exampleDisagree,
                      style: TextStyle(
                        fontSize: adaptDp(14),
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      exit(exitCode);
                    },
                  ),
                ),
                const VerticalDivider(width: 0.5),
                Expanded(
                  child: BaseBackgroundButton(
                    borderRadius: 0,
                    title: Text(
                      S.of(context).exampleAgree,
                      style: TextStyle(
                        fontSize: adaptDp(14),
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      setStorageBool(kPrivacy, true);
                      Navigator.of(context).pop(true);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ) ??
      false;
}
