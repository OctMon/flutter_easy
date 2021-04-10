import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

export 'constant.dart';
export 'package:session/session.dart' show Result;

Config _config(String baseURL) {
  Config.logEnable = false;

  return Config(
      baseUrl: baseURL ?? "https://api.tuchong.com/",
//    proxy: 'PROXY localhost:8888',
      connectTimeout: 10,
      receiveTimeout: 10,
      code: "result",
      validCode: "SUCCESS",
      list: "feedList");
}

InterceptorSendCallback _onRequest = (options) async {
  logRequest(options);
  return options;
};

/// 响应结果拦截处理
Result _onValidResult<T>(
    Result result, bool validResult, BuildContext context) {
  logResponse(result);
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
Future<Result> getAPI(
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
//      log('showLoading(); error:', e.toString());
    }
  }
  Session session = Session(
    config: _config(baseUrl),
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
