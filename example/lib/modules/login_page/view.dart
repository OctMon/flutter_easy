import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy/flutter_easy.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(LoginState state, Dispatch dispatch, ViewService viewService) {
  return BaseScaffold(
    appBar: BaseAppBar(
      automaticallyImplyLeading: false,
      brightness: Brightness.light,
      actions: <Widget>[
        BaseButton(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          child: BaseTitle(
            '取消',
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          onPressed: () => Navigator.pop(viewService.context, false),
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
                      controller: state.phoneNumberController,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      maxLength: 11,
                      placeholder: '请输入手机号',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ]),
                  SizedBox(height: 15),
                  BaseTextField(
                    controller: state.passwordController,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    maxLength: 16,
                    placeholder: '请输入密码',
                    obscureText: true,
                    keyboardType: TextInputType.text,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 15),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            BaseButton(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: BaseTitle(
                                "新用户注册",
                                fontSize: adaptDp(14),
                                color: colorWithTint,
                              ),
                              onPressed: () async {},
                            ),
                            BaseButton(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: BaseTitle(
                                "忘记密码？",
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
                            '登录',
                            color: Colors.white,
                            fontSize: adaptDp(16),
                            fontWeight: FontWeight.normal,
                          ),
                          onPressed: () =>
                              dispatch(LoginActionCreator.onLoginPressed()),
                        ),
                      ],
                    ),
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
                  GestureDetector(
                    onTap: () {
                      dispatch(LoginActionCreator.updateAgreementCheck(
                          !state.isChecked));
                    },
                    child: Icon(
                      state.isChecked
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      size: adaptDp(20),
                      color: state.isChecked ? colorWithTint : colorWithHex9,
                    ),
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
                            text: "我已阅读并同意" + appName,
                          ),
                          TextSpan(
                            text: "《用户协议》",
                            style: TextStyle(
                              color: colorWithTint,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                          TextSpan(
                            text: '和',
                          ),
                          TextSpan(
                            // 《隐私政策》
                            text: "《隐私政策》",
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
