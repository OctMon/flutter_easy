import 'package:dio/dio.dart';
import 'package:flutter_easy/flutter_easy.dart';

export 'constant.dart';

Config _config(String? baseURL) {
  Config.logEnable = false;

  return Config(
      baseUrl: baseURL ?? "https://api.tuchong.com/",
//    proxy: 'PROXY localhost:8888',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      errorTimeout: kPlaceholderTitleRemote,
      errorConnection: kPlaceholderTitleRemote,
      errorBadResponse: kPlaceholderTitleRemote,
      code: "result",
      validCode: "SUCCESS",
      list: "feedList");
}

/// 响应结果拦截处理
Result _onValidResult<T>(Result result, bool validResult) {
  logResponse(result);
  return result;
}

///
/// 发送请求并解析远程服务器返回的result对应的实体类型
///
/// baseUrl: 主机地址
/// path: 请求路径
/// queryParameters: URL携带请求参数
/// validResult: 是否检验返回结果
/// autoLoading: 展示Loading
///
Future<Result> getAPI(
    {String? baseUrl,
    String path = '',
    Map<String, dynamic>? queryParameters,
    bool validResult = true,
    bool autoLoading = false}) async {
  return requestAPI(
      baseUrl: baseUrl,
      path: path,
      queryParameters: queryParameters,
      options: Options(method: 'get'),
      validResult: validResult,
      autoLoading: autoLoading);
}

///
/// 发送请求并解析远程服务器返回的result对应的实体类型
///
/// baseUrl: 主机地址
/// path: 请求路径
/// data: 请求参数
/// validResult: 是否检验返回结果
/// autoLoading: 展示Loading
///
Future<Result> postAPI(
    {String? baseUrl,
    String path = '',
    data,
    bool validResult = true,
    bool autoLoading = false}) async {
  return requestAPI(
      baseUrl: baseUrl,
      path: path,
      data: data,
      options: Options(method: 'post'),
      validResult: validResult,
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
/// autoLoading: 展示Loading
///
Future<Result> requestAPI(
    {String? baseUrl,
    String path = '',
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool validResult = true,
    bool autoLoading = false}) async {
  if (autoLoading) {
    showLoading();
  }
  Session session = Session(
    config: _config(baseUrl),
    onRequest: (options) async {
      logRequest(options);
      return options;
    },
  );
  Result result = await session.request(path,
      data: data, queryParameters: queryParameters, options: options);
  if (autoLoading) {
    // Dismiss loading
    dismissLoading();
  }
  return _onValidResult(result, validResult);
}
