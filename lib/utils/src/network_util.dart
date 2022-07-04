import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:url_launcher/url_launcher_string.dart';

export 'package:session/session.dart';

/// 网络错误的提示语
String? kPlaceholderTitleRemote = "网络连接出错，请检查网络连接";

/// URL环境
enum BaseURLType { test, release }

/// 存储当前环境的key
String _baseURLTypeKey = "$BaseURLType".md5;

/// 当前环境
var _baseURLTypeString = "".obs;

/// 上线环境
BaseURLType get kBaseURLType {
  if (isAppDebugFlag && _baseURLTypeString.value.isNotEmpty) {
    if (_baseURLTypeString.value == "${BaseURLType.test}") {
      return BaseURLType.test;
    } else if (_baseURLTypeString.value == "${BaseURLType.release}") {
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

String kApiPath = "";

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

/// 每页数量
String kPageCountKey = '';

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
  if (autoLoading) {
    showLoading();
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
  if (autoLoading) {
    dismissLoading();
  }
  return _onResult != null ? _onResult!(result, validResult) : result;
}

Future<String?> initSelectedBaseURLType() async {
  String? urlType =
      await SharedPreferencesUtil.getSharedPrefsString(_baseURLTypeKey);
  if (urlType?.isNotEmpty ?? false) {
    _baseURLTypeString.value = urlType ?? "";
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
    _baseURLTypeString.value = "$urlType";
    logInfo("$_baseURLTypeKey = ${_baseURLTypeString.value}");
    return SharedPreferencesUtil.setSharedPrefsString(
        _baseURLTypeKey, _baseURLTypeString.value);
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
        title: Text(_baseURLTypeString.value.isEmpty
            ? "$kBaseURLType"
            : _baseURLTypeString.value),
        content: Text(
          "${BaseURLType.test}=\n$kTestBaseURL\n\n${BaseURLType.release}=\n$kReleaseBaseURL",
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
            child: const Text("取消"),
            onPressed: () {
              Navigator.pop(ctx, false);
            },
          ),
        ],
      );
    },
  );
}

checkVersion(String action, String baseUrl) async {
  await 3.delay();
  if (isPhone && isAppDebugFlag) {
    final result =
        await get(baseUrl: "${baseUrl}_${isAndroid ? "apk" : "ipa"}.version");
    if (result.response?.statusCode == 200) {
      final version = result.body["version"] as String;
      if (version.contains("+")) {
        final build = int.parse(version.split("+").last);
        if (Get.context != null && build > int.parse(appBuildNumber)) {
          showBaseDialog(
              context: Get.context!,
              builder: (BuildContext context) {
                return BaseGeneralAlertDialog(
                  title: Text("新版本"),
                  actions: [
                    BaseDialogAction(
                      child: Text("立即更新"),
                      onPressed: () async {
                        offBack();
                        final app =
                            isIOS ? "$action$baseUrl.plist" : "$baseUrl.apk";
                        logDebug(app);
                        if (isIOS) {
                          final success = await canLaunch(app);
                          if (success) {
                            onLaunch(app);
                          }
                        } else {
                          onLaunch(app, mode: LaunchMode.externalApplication);
                        }
                      },
                    ),
                    BaseDialogAction(
                      child: Text("以后再说"),
                      onPressed: () {
                        offBack();
                      },
                    ),
                  ],
                );
              });
        }
      }
    }
  }
}
