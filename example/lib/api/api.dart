import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/store/user_store/store.dart';

export 'constant.dart';
export 'package:session/session.dart' show Result;

void configAPI(String baseURL) {
  Config.logEnable = false;

  /// 测试环境
  kTestBaseURL = "http://www.httpbin.org/";

  /// 生产环境
  kReleaseBaseURL = "https://www.httpbin.org/";

  NetworkUtil.init(
    Session(
        config: Config(
          baseUrl: baseURL ??
              (kBaseURLType == BaseURLType.release
                  ? kReleaseBaseURL
                  : kTestBaseURL),
//    proxy: 'PROXY localhost:8888',
          connectTimeout: 10,
          receiveTimeout: 10,
        ),
        onRequest: _onRequest),
    onResult: _onValidResult,
  );
}

InterceptorSendCallback _onRequest = (options) async {
  var headers = {
    'os': isIOS ? 'ios' : 'android',
  };
  options.headers.addAll(headers);
  if (UserStore.store.getState().isLogin) {
    options.headers['id'] = UserStore.store.getState().user.userId;
  }
  // options.contentType = Headers.formUrlEncodedContentType;
  // options.responseType = ResponseType.plain;

  logRequest(options);
  return options;
};

/// 响应结果拦截处理
Result _onValidResult<T>(
    Result result, bool validResult, BuildContext context) {
  logResponse(result);
  // 拦截处理一些错误
  if (validResult) {
    switch (result.code) {
      // case "${-3}":
      //   // 强更
      //   break;
//      case "${-2}":
//        // token过期
//        if (UserUtil.isLogin) {
//          UserUtil.logout().then((_) {
//            // 跳转到登录页面
//            if (context != null) {
//              Navigator.of(context)
//                  .pushNamedAndRemoveUntil('/', ModalRoute.withName(''));
////    showToast(result.message);
//              pushNamedToLogin(context);
//            }
//          });
//        }
//        break;
    }
  }
  return result;
}
