import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:session/session.dart';
import 'package:flutter_easy/flutter_easy.dart';

import 'global_util.dart';
import 'loading_util.dart';
import 'logger_util.dart';
import 'shared_preferences_util.dart';

export 'package:session/session.dart';

/// URL环境
enum BaseURLType { test, release }

/// 存储当前环境的key
String _baseURLTypeKey = "$BaseURLType".md5;

/// 当前环境
String _baseURLTypeString = "";

/// 上线环境
BaseURLType get kBaseURLType {
  if (isAppDebugFlag && _baseURLTypeString.isNotEmpty) {
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
late String kTestBaseURL;

/// 生产环境
late String kReleaseBaseURL;

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

/// BaseURL变化回调
VoidCallback? baseURLChangedCallback;

typedef _ResultCallBack = Result Function(Result result, bool validResult);

class NetworkUtil {
  NetworkUtil._();

  static init(Session session, {_ResultCallBack? onResult}) {
    _session = session;
    _onResult = onResult;
  }
}

late Session _session;

_ResultCallBack? _onResult;

///
/// 发送请求并解析远程服务器返回的result对应的实体类型
///
/// baseUrl: 主机地址
/// path: 请求路径
/// queryParameters: URL携带请求参数
/// connectTimeout: 超时时间
/// validResult: 是否检验返回结果
/// autoLoading: 展示Loading
///
Future<Result> get(
    {String? baseUrl,
    String path = '',
    Map<String, dynamic>? queryParameters,
    int? connectTimeout,
    bool validResult = true,
    bool autoLoading = false}) async {
  return request(
      baseUrl: baseUrl,
      path: path,
      queryParameters: queryParameters,
      options: Options(method: 'get'),
      connectTimeout: connectTimeout,
      validResult: validResult,
      autoLoading: autoLoading);
}

///
/// 发送请求并解析远程服务器返回的result对应的实体类型
///
/// baseUrl: 主机地址
/// path: 请求路径
/// data: 请求参数
/// connectTimeout: 超时时间
/// validResult: 是否检验返回结果
/// autoLoading: 展示Loading
///
Future<Result> post(
    {String? baseUrl,
    String path = '',
    data,
    int? connectTimeout,
    bool validResult = true,
    bool autoLoading = false}) async {
  return request(
      baseUrl: baseUrl,
      path: path,
      data: data,
      options: Options(method: 'post'),
      connectTimeout: connectTimeout,
      validResult: validResult,
      autoLoading: autoLoading);
}

///
/// 发送请求并解析远程服务器返回的result对应的实体类型
///
/// baseUrl: 主机地址
/// path: 请求路径
/// data: 请求参数
/// connectTimeout: 超时时间
/// validResult: 是否检验返回结果
/// autoLoading: 展示Loading
///
Future<Result> request(
    {String? baseUrl,
    String path = '',
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    int? connectTimeout,
    bool validResult = true,
    bool autoLoading = false}) async {
  // Loading is show
  bool alreadyShowLoading = false;
  if (autoLoading) {
    try {
      showLoading();
      alreadyShowLoading = true;
    } catch (e) {
      logError('showLoading()', e.toString());
    }
  }
  Session session = Session(
      config: Config(
          baseUrl:
              baseUrl?.isNotEmpty == true ? baseUrl! : _session.config.baseUrl,
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
  Result result = await session.request(
    path,
    data: data,
    queryParameters: queryParameters,
    options: options,
    connectTimeout: connectTimeout,
  );
  if (autoLoading && alreadyShowLoading) {
    // Dismiss loading
    dismissLoading();
  }
  return _onResult != null ? _onResult!(result, validResult) : result;
}

Future<String?> initSelectedBaseURLType() async {
  String? urlType =
      await SharedPreferencesUtil.getSharedPrefsString(_baseURLTypeKey);
  if (urlType?.isNotEmpty ?? false) {
    _baseURLTypeString = urlType ?? "";
  }
  return urlType;
}

/// 弹出切换环境菜单
Future<bool?> showSelectBaseURLTypeAlert({BuildContext? context}) {
  if (!isAppDebugFlag) {
    return Future.value(false);
  }

  /// 保存选择的环境
  Future<bool> save(BaseURLType urlType) {
    _baseURLTypeString = "$urlType";
    logInfo("$_baseURLTypeKey = " + _baseURLTypeString);
    return SharedPreferencesUtil.setSharedPrefsString(
        _baseURLTypeKey, _baseURLTypeString);
  }

  if (context == null) {
    return save(kBaseURLType == BaseURLType.test
        ? BaseURLType.release
        : BaseURLType.test);
  }

  return showBaseDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext ctx) {
      return BaseGeneralAlertDialog(
        title: Text(
            _baseURLTypeString.isEmpty ? "$kBaseURLType" : _baseURLTypeString),
        content: Text(
          "${BaseURLType.test}" +
              "=\n" +
              (kTestBaseURL) +
              "\n\n"
                  "${BaseURLType.release}" +
              "=\n" +
              (kReleaseBaseURL),
        ),
        actions: <Widget>[
          BaseDialogAction(
            isDestructiveAction: true,
            child: Text("${BaseURLType.test}"),
            onPressed: () async {
              await save(BaseURLType.test);
              if (baseURLChangedCallback != null) {
                baseURLChangedCallback!();
              }
              Navigator.pop(ctx, true);
            },
          ),
          BaseDialogAction(
            isDefaultAction: true,
            child: Text("${BaseURLType.release}"),
            onPressed: () async {
              await save(BaseURLType.release);
              if (baseURLChangedCallback != null) {
                baseURLChangedCallback!();
              }
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
