import 'package:flutter_easy/flutter_easy.dart';

import '../routes.dart';
import '../store/user/store.dart';

extension BasePathExtension on String {
  String get baseApi => "$kApiPath$this";
}

Future<void> configAPI(String? baseURL) async {
  Config.logEnable = false;

  /// 测试环境
  kTestBaseURL = "https://www.mxnzp.com/";

  /// 生产环境
  kReleaseBaseURL = "https://www.mxnzp.com/";

  kApiPath = "api/";

  kFirstPage = 1;

  const appId = String.fromEnvironment("app_id");
  const appSecret = String.fromEnvironment("app_secret");

  NetworkUtil.init(
    Session(
      config: Config(
        baseUrl: baseURL ??
            (kBaseURLType == BaseURLType.release
                ? kReleaseBaseURL
                : kTestBaseURL),
//    proxy: 'PROXY localhost:8888',
        connectTimeout: 30.seconds,
        receiveTimeout: 30.seconds,
        validCode: "1",
        message: "msg",
      ),
      onRequest: (options) async {
        // var headers = {
        //   'deviceOs': operatingSystem,
        //   'version': appBuildNumber,
        //   'lang': Intl.getCurrentLocale()
        // };
        // options.headers.addAll(headers);
        // if (UserStore.find.isLogin) {
        //   options.headers['id'] = UserStore.find.user.value.userId;
        // }
        // options.contentType = Headers.formUrlEncodedContentType;
        // options.responseType = ResponseType.plain;
        options.queryParameters["app_id"] = appId;
        options.queryParameters["app_secret"] = appSecret;
        logRequest(options);
        return options;
      },
    ),
    onResult: _onValidResult,
  );
}

/// 响应结果拦截处理
Future<Result> _onValidResult(Result result, bool validResult, extra) async {
  logResponse(result);
  // 拦截处理一些错误
  if (validResult) {
    if (result.response?.statusCode == 401) {
      // 跳转到登录页面
      toLogin();
      return result;
    }
    switch (result.code) {
      // case "${-3}":
      //   // 强更
      //   break;
      case "${2}":
        // token过期
        if (UserStore.find.isLogin) {
          // showToast(result.message);
          UserStore.find.clean().then((_) async {
            // 跳转到闪屏页 以游客身份登录
            await offAllNamed(Routes.splash);
          });
        }
        break;
    }
  }
  return result;
}
