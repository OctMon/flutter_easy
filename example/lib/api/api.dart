import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/store/user/store.dart';

export 'constant.dart';
export 'package:session/session.dart' show Result;

void configAPI(String? baseURL) {
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
      onRequest: (options) async {
        var headers = {
          'os': isIOS ? 'ios' : 'android',
        };
        options.headers.addAll(headers);
        if (UserStore.find.isLogin) {
          options.headers['id'] = UserStore.find.user.value.userId;
        }
        // options.contentType = Headers.formUrlEncodedContentType;
        // options.responseType = ResponseType.plain;

        logRequest(options);
        return options;
      },
    ),
    onResult: _onValidResult,
  );
}

/// 响应结果拦截处理
Result _onValidResult(Result result, bool validResult) {
  logResponse(result);
  // 拦截处理一些错误
  if (validResult) {
    switch (result.code) {
      // case "${-3}":
      //   // 强更
      //   break;
      // case "${-2}":
      //   // token过期
      //   if (UserService.find.isLogin) {
      //     UserService.find.clean().then((_) async {
      //       // 跳转到登录页面
      //       await offAllNamed(Routes.root);
      //       toLogin();
      //     });
      //   }
      // break;
    }
  }
  return result;
}
