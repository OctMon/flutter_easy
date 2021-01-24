import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/store/user_store/store.dart';

export 'constant.dart';
export 'package:session/session.dart' show Result;

Config configApi(String baseURL) {
  Config.logEnable = false;

  /// 测试环境
  kTestBaseURL = "http://www.httpbin.org/";

  /// 生产环境
  kReleaseBaseURL = "https://www.httpbin.org/";

  return Config(
    baseUrl: baseURL ??
        (kBaseURLType == BaseURLType.release ? kReleaseBaseURL : kTestBaseURL),
//    proxy: 'PROXY localhost:8888',
    connectTimeout: 10,
    receiveTimeout: 10,
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

///
/// 发送请求并解析远程服务器返回的result对应的实体类型
///
/// baseUrl: 主机地址
/// path: 请求路径
/// data: 请求参数
/// queryParameters: URL携带请求参数
/// validResult: 是否检验返回结果
/// context: 上下文
/// autoLoading: 展示Loading
///
Future<Result> getApi(
    {String baseUrl,
    String path = '',
    Map data,
    Map<String, dynamic> queryParameters,
    bool validResult = true,
    BuildContext context,
    bool autoLoading = false}) async {
  return requestAPI(
      baseUrl: baseUrl,
      path: path,
      data: data,
      queryParameters: queryParameters,
      options: Options(method: 'get'),
      validResult: validResult,
      context: context,
      autoLoading: autoLoading);
}

///
/// 发送请求并解析远程服务器返回的result对应的实体类型
///
/// baseUrl: 主机地址
/// path: 请求路径
/// data: 请求参数
/// validResult: 是否检验返回结果
/// context: 上下文
/// autoLoading: 展示Loading
///
Future<Result> postAPI(
    {String baseUrl,
    String path = '',
    Map data,
    bool validResult = true,
    BuildContext context,
    bool autoLoading = false}) async {
  return requestAPI(
      baseUrl: baseUrl,
      path: path,
      data: data,
      options: Options(method: 'post'),
      validResult: validResult,
      context: context,
      autoLoading: autoLoading);
}

///
/// 发送请求并解析远程服务器返回的result对应的实体类型
///
/// <T>: 要解析的实体类名(需要自动转换时必须要加)
/// baseUrl: 主机地址
/// path: 请求路径
/// data: 请求参数
/// validResult: 是否检验返回结果
/// context: 上下文
/// autoLoading: 展示Loading
///
Future<Result> requestAPI(
    {String baseUrl,
    String path = '',
    Map data,
    Map<String, dynamic> queryParameters,
    Options options,
    bool validResult = true,
    BuildContext context,
    bool autoLoading = false}) async {
  // Loading is show
  bool alreadyShowLoading = false;
  if (autoLoading && context != null) {
    try {
      showLoading(context);
      alreadyShowLoading = true;
    } catch (e) {
      logError('showLoading(); error:', e.toString());
    }
  }
  Session session = Session(
    config: configApi(baseUrl),
    onRequest: _onRequest,
  );
  Result result = await session.request(path,
      data: data, queryParameters: queryParameters, options: options);
  if (autoLoading && alreadyShowLoading) {
    // Dismiss loading
    dismissLoading(context);
  }
  return _onValidResult(result, validResult, context);
}
