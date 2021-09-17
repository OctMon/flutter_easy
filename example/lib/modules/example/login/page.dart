import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/generated/l10n.dart';

import 'controller.dart';
import 'state.dart';

class LoginPage extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());
  final LoginState state = Get.find<LoginController>().state;

  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          BaseButton(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            child: Text(
              S.of(context).cancel,
            ),
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      ),
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
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: <Widget>[
                    BaseTextField(
                        backgroundColor: appDarkMode(context)
                            ? Colors.white30
                            : Colors.black12,
                        controller: state.phoneNumberController,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        maxLength: 11,
                        placeholder: S.of(context).example_InputPhoneNumber,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ]),
                    const SizedBox(height: 15),
                    BaseTextField(
                      backgroundColor: appDarkMode(context)
                          ? Colors.white30
                          : Colors.black12,
                      controller: state.passwordController,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
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
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                S.of(context).example_NewUserRegister,
                              ),
                              onPressed: () async {},
                            ),
                            BaseButton(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                S.of(context).example_ForgetPassword,
                              ),
                              onPressed: () async {},
                            ),
                          ],
                        ),
                        BaseGradientButton(
                          borderRadius: 5,
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(0, 3),
                              blurRadius: 12,
                              color: Color(0xFFFFB9BF),
                            ),
                          ],
                          height: 50,
                          title: Text(
                            S.of(context).login,
                          ),
                          onPressed: () => controller.onLoginPressed(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(15),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ObxValue<Rx<bool>>(
                      (checked) => GestureDetector(
                        onTap: () {
                          checked.toggle();
                          state.update(checked.value);
                        },
                        child: Icon(
                          checked.value
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          size: adaptDp(20),
                          color: checked.value
                              ? setLightPrimaryColor
                              : colorWithHex9,
                        ),
                      ),
                      false.obs,
                    ),
                    const SizedBox(width: 2),
                    Flexible(
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontSize: adaptDp(12),
                            color: const Color(0xff7a7a7a),
                          ),
                          children: [
                            TextSpan(
                              text:
                                  S.of(context).example_ReadAndAgree + appName,
                            ),
                            TextSpan(
                              text: S.of(context).example_UserAgreement,
                              style: TextStyle(
                                color: setLightPrimaryColor,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                            TextSpan(
                              text: S.of(context).example_And,
                            ),
                            TextSpan(
                              text: S.of(context).example_PrivacyPolicy,
                              style: TextStyle(
                                color: setLightPrimaryColor,
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
