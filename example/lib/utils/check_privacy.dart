import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/generated/l10n.dart';

import '../app.dart';
import '../routes.dart';

Future<bool> checkPrivacy() async {
  if (await getStorageBool(kNonFirstUseAppKey) == true) {
    return false;
  }

  return await showBaseAlert<bool>(PopScope(
        canPop: false,
        child: BaseAlertDialog(
          title: Text(
            "$appName${S.current.example_UserAgreement}${S.current.example_And}\n${S.current.example_PrivacyPolicy}",
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
                      text: S.current.exampleCheckPrivacyAlertBegin,
                    ),
                    TextSpan(
                      text: S.current.example_UserAgreement,
                      style: TextStyle(
                        color: Get.theme.primaryColor,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () =>
                            toNamed(Routes.photosTab, preventDuplicates: false),
                    ),
                    TextSpan(
                      text: S.current.example_And,
                    ),
                    TextSpan(
                      text: S.current.example_PrivacyPolicy,
                      style: TextStyle(
                        color: Get.theme.primaryColor,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () =>
                            toNamed(Routes.photosTab, preventDuplicates: false),
                    ),
                    TextSpan(
                      text: S.current.exampleCheckPrivacyAlertEnd,
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Expanded(
              child: SizedBox(
                height: 44,
                child: BaseTextButton(
                  borderRadius:
                      const BorderRadius.only(bottomLeft: Radius.circular(10)),
                  child: Text(
                    S.current.exampleDisagree,
                    style: TextStyle(
                      fontSize: adaptDp(14),
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    exit(exitCode);
                  },
                ),
              ),
            ),
            const VerticalDivider(width: 0.5),
            Expanded(
              child: SizedBox(
                height: 44,
                child: BaseTextButton(
                  borderRadius:
                      const BorderRadius.only(bottomRight: Radius.circular(10)),
                  child: Text(
                    S.current.exampleAgree,
                    style: TextStyle(
                      fontSize: adaptDp(14),
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    setStorageBool(kNonFirstUseAppKey, true);
                    offBack(true);
                  },
                ),
              ),
            ),
          ],
        ),
      )) ??
      false;
}
