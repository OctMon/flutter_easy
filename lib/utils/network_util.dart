import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:session/session.dart';

import '../components/base.dart';
import '../utils/loading_util.dart';
import '../utils/logger_util.dart';
import '../utils/crypto_util.dart';
import 'global_util.dart';
import 'shared_preferences_util.dart';

export 'package:session/session.dart';

/// URL环境
enum BaseURLType { test, release }

/// 存储当前环境的key
String _baseURLTypeKey = md5("$BaseURLType");

/// 当前环境
String _baseURLTypeString;

/// 开户环境切换，需要自己埋入口
bool isSelectBaseURLTypeFlag = false;

/// 上线环境
BaseURLType get kBaseURLType {
  if (isSelectBaseURLTypeFlag && _baseURLTypeString != null) {
    if (_baseURLTypeString == "${BaseURLType.test}") {
      return BaseURLType.test;
    } else if (_baseURLTypeString == "${BaseURLType.release}") {
      return BaseURLType.release;
    }
  }
  if (isProduction) {
    return BaseURLType.release;
  } else {
    return BaseURLType.test;
  }
}

/// 测试环境
String kTestBaseURL;

/// 生产环境
String kReleaseBaseURL;

/// 列表无数据
String kEmptyList = "暂无内容";

/// 分页时第一页的起始页值
int kFirstPage = 1;

/// 分页时每页数量
int kLimitPage = 20;

/// 页码数
String kPageKey = 'page';

/// 每页数量
String kPageSizeKey = 'pagesize';

typedef _ResultCallBack = Result Function<T>(
    Result result, bool validResult, BuildContext context);

class NetworkUtil {
  NetworkUtil._();

  static init(Session session, {_ResultCallBack onResult}) {
    _session = session;
    _onResult = onResult;
  }
}

Session _session;

_ResultCallBack _onResult;

///
/// 发送请求并解析远程服务器返回的result对应的实体类型
///
/// <T>: 要解析的实体类名(需要自动转换时必须要加)
/// baseUrl: 主机地址
/// path: 请求路径
/// data: 请求参数
/// queryParameters: URL携带请求参数
/// validResult: 是否检验返回结果
/// context: 上下文
/// autoLoading: 展示Loading
///
Future<Result> get<T>(
    {String baseUrl,
    String path = '',
    Map data,
    Map<String, dynamic> queryParameters,
    bool validResult = true,
    BuildContext context,
    bool autoLoading = false}) async {
  return request<T>(
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
/// <T>: 要解析的实体类名(需要自动转换时必须要加)
/// baseUrl: 主机地址
/// path: 请求路径
/// data: 请求参数
/// validResult: 是否检验返回结果
/// context: 上下文
/// autoLoading: 展示Loading
///
Future<Result> post<T>(
    {String baseUrl,
    String path = '',
    Map data,
    bool validResult = true,
    BuildContext context,
    bool autoLoading = false}) async {
  return request<T>(
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
Future<Result> request<T>(
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
      logError('showLoading()', e.toString());
    }
  }
  Session session = Session(
      config: Config(
          baseUrl:
              baseUrl?.isNotEmpty == true ? baseUrl : _session.config.baseUrl,
          proxy: _session.config.proxy,
          badCertificateCallback: _session.config.badCertificateCallback,
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
  if (autoLoading && alreadyShowLoading) {
    // Dismiss loading
    dismissLoading(context);
  }
  return _onResult != null
      ? _onResult<T>(result, validResult, context)
      : result;
}

Future<String> initSelectedBaseURLType() async {
  String urlType =
      await SharedPreferencesUtil.getSharedPrefsString(_baseURLTypeKey);
  if (urlType != null && urlType.isNotEmpty) {
    _baseURLTypeString = urlType;
  }
  return urlType;
}

/// 弹出切换环境菜单
Future<bool> showSelectBaseURLTypeAlert({@required BuildContext context}) {
  if (!isSelectBaseURLTypeFlag) {
    return Future.value(false);
  }

  /// 保存选择的环境
  Future<bool> save(BaseURLType urlType) {
    _baseURLTypeString = "$urlType";
    logInfo("$_baseURLTypeKey = " + _baseURLTypeString);
    return SharedPreferencesUtil.setSharedPrefsString(
        _baseURLTypeKey, _baseURLTypeString);
  }

  return showBaseDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext ctx) {
      return BaseGeneralAlertDialog(
        title: Text(
            _baseURLTypeString == null ? "$kBaseURLType" : _baseURLTypeString),
        content: Text(
          "${BaseURLType.test}" +
              "=\n" +
              (kTestBaseURL ?? "unknown") +
              "\n\n"
                  "${BaseURLType.release}" +
              "=\n" +
              (kReleaseBaseURL ?? "unknown"),
        ),
        actions: <Widget>[
          BaseDialogAction(
            isDestructiveAction: true,
            child: Text("${BaseURLType.test}"),
            onPressed: () async {
              await save(BaseURLType.test);
              Navigator.pop(ctx, true);
            },
          ),
          BaseDialogAction(
            isDefaultAction: true,
            child: Text("${BaseURLType.release}"),
            onPressed: () async {
              await save(BaseURLType.release);
              Navigator.pop(ctx, true);
            },
          ),
          BaseDialogAction(
            child: Text("取消"),
            onPressed: () {
              Navigator.pop(ctx, false);
            },
          ),
        ],
      );
    },
  );
}
