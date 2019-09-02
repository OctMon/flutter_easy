import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:session/session.dart';

import '../utils/loading_utils.dart';
import '../utils/logger_utils.dart';

export 'package:session/session.dart';

setSession(Session session) {
  _session = session;
}

Session _session;

///
/// 发送请求并解析远程服务器返回的result对应的实体类型
///
/// <T>: 要解析的实体类名(需要自动转换时必须要加)
/// baseUrl: 主机地址
/// path: 请求路径
/// data: 请求参数
/// queryParameters: URL携带请求参数
/// validResult: 是否检验返回结果
/// context: 不为null时展示Loading
///
Future<Result> get<T>(
    {String baseUrl,
    String path = '',
    Map data,
    Map<String, dynamic> queryParameters,
    bool validResult = true,
    BuildContext context}) async {
  return request<T>(baseUrl,
      path: path,
      data: data,
      queryParameters: queryParameters,
      options: Options(method: 'get'),
      validResult: validResult,
      context: context);
}

///
/// 发送请求并解析远程服务器返回的result对应的实体类型
///
/// <T>: 要解析的实体类名(需要自动转换时必须要加)
/// baseUrl: 主机地址
/// path: 请求路径
/// data: 请求参数
/// validResult: 是否检验返回结果
/// context: 不为null时展示Loading
///
Future<Result> post<T>(
    {String baseUrl,
    String path = '',
    Map data,
    bool validResult = true,
    BuildContext context}) async {
  return request<T>(baseUrl,
      path: path,
      data: data,
      options: Options(method: 'post'),
      validResult: validResult,
      context: context);
}

///
/// 发送请求并解析远程服务器返回的result对应的实体类型
///
/// <T>: 要解析的实体类名(需要自动转换时必须要加)
/// baseUrl: 主机地址
/// path: 请求路径
/// data: 请求参数
/// validResult: 是否检验返回结果
/// context: 不为null时展示Loading
///
Future<Result> request<T>(String baseUrl,
    {String path = '',
    Map data,
    Map<String, dynamic> queryParameters,
    Options options,
    bool validResult = true,
    BuildContext context}) async {
  // Loading is show
  bool alreadyShowLoading = false;
  if (context != null) {
    try {
      showLoading(context: context);
      alreadyShowLoading = true;
    } catch (e) {
      log('showLoading(); error:', e.toString());
    }
  }
  Session session = Session(
      config: Config(
          baseUrl: _session.config.baseUrl ?? baseUrl,
          proxy: _session.config.proxy,
          connectTimeout: _session.config.connectTimeout,
          receiveTimeout: _session.config.receiveTimeout,
          code: _session.config.code,
          data: _session.config.data,
          list: _session.config.list,
          message: _session.config.message,
          validCode: _session.config.validCode,
          errorTimeout: _session.config.errorTimeout,
          errorResponse: _session.config.errorResponse,
          errorCancel: _session.config.errorCancel,
          errorOther: _session.config.errorOther),
      onRequest: _session.onRequest,
      onResult: validResult ? _session.onResult : null);
  Result result = await session.request(path,
      data: data, queryParameters: queryParameters, options: options);
  if (alreadyShowLoading) {
    // Dismiss loading
    dismissLoading(context: context);
  }
  return result;
}
