import 'package:dio/dio.dart';
import 'package:flutter_easy/flutter_easy.dart';

export 'constant.dart';
export 'package:session/session.dart' show Result;

Config _config(String? baseURL) {
  Config.logEnable = false;

  return Config(
    baseUrl: baseURL ??
        "http${kBaseURLType == BaseURLType.release ? 's' : ''}://httpbin.org/",
//    proxy: 'PROXY localhost:8888',
    connectTimeout: 10,
    receiveTimeout: 10,
  );
}

SessionInterceptorSendHandler _onRequest = (options) async {
  logRequest(options);
  return options;
};

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
Future<Result> getHttpBin(
    {String? baseUrl,
    String path = '',
    Map<String, dynamic>? queryParameters,
    bool validResult = true,
    bool autoLoading = false}) async {
  return requestHttpBin(
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
Future<Result> postHttpBin(
    {String? baseUrl,
    String path = '',
    data,
    bool validResult = true,
    bool autoLoading = false}) async {
  return requestHttpBin(
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
Future<Result> requestHttpBin(
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
    onRequest: _onRequest,
  );
  Result result = await session.request(path,
      data: data, queryParameters: queryParameters, options: options);
  if (autoLoading) {
    // Dismiss loading
    dismissLoading();
  }
  return _onValidResult(result, validResult);
}
