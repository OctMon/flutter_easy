import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/generated/l10n.dart';

import 'controller.dart';
import 'state.dart';

class LoginPage extends StatelessWidget {
  final LoginLogic logic = Get.put(LoginLogic());
  final LoginState state = Get.find<LoginLogic>().state;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        automaticallyImplyLeading: false,
        brightness: Brightness.light,
        actions: <Widget>[
          BaseButton(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            child: BaseTitle(
              S.of(context).cancel,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          FlutterLogo(
            size: adaptDp(100),
            style: FlutterLogoStyle.markOnly,
          ),
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: <Widget>[
                    BaseTextField(
                        controller: logic.state.phoneNumberController,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        maxLength: 11,
                        placeholder: S.of(context).example_InputPhoneNumber,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ]),
                    SizedBox(height: 15),
                    BaseTextField(
                      controller: logic.state.passwordController,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      maxLength: 16,
                      placeholder: S.of(context).example_InputPassword,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            BaseButton(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: BaseTitle(
                                S.of(context).example_NewUserRegister,
                                fontSize: adaptDp(14),
                                color: colorWithTint,
                              ),
                              onPressed: () async {},
                            ),
                            BaseButton(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: BaseTitle(
                                S.of(context).example_ForgetPassword,
                                fontSize: adaptDp(14),
                                color: colorWithTint,
                              ),
                              onPressed: () async {},
                            ),
                          ],
                        ),
                        BaseGradientButton(
                          borderRadius: 5,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 3),
                              blurRadius: 12,
                              color: Color(0xFFFFB9BF),
                            ),
                          ],
                          height: 50,
                          title: BaseTitle(
                            S.of(context).login,
                            color: Colors.white,
                            fontSize: adaptDp(16),
                            fontWeight: FontWeight.normal,
                          ),
                          onPressed: () => logic.onLoginPressed(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(15),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GetX<LoginLogic>(
                      init: logic,
                      builder: (_) {
                        return GestureDetector(
                          onTap: () {
                            state.update(!state.isChecked);
                            // dispatch(LoginActionCreator.updateAgreementCheck(
                            //     !state.isChecked));
                          },
                          child: Icon(
                            state.isChecked
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            size: adaptDp(20),
                            color:
                                state.isChecked ? colorWithTint : colorWithHex9,
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 2),
                    Flexible(
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontSize: adaptDp(12),
                            color: Color(0xff7a7a7a),
                          ),
                          children: [
                            TextSpan(
                              text:
                                  S.of(context).example_ReadAndAgree + appName,
                            ),
                            TextSpan(
                              text: S.of(context).example_UserAgreement,
                              style: TextStyle(
                                color: colorWithTint,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                            TextSpan(
                              text: S.of(context).example_And,
                            ),
                            TextSpan(
                              text: S.of(context).example_PrivacyPolicy,
                              style: TextStyle(
                                color: colorWithTint,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // width: adaptDp(125.0),
              )
            ],
          ),
          Container(),
        ],
      ),
    );
  }
}
