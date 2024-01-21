import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

void _log(String tag, dynamic value, {StackTrace? stackTrace}) {
  if (isDebug || isAppDebugFlag) {
    developer.log("${DateTime.now()} $value",
        time: DateTime.now(), name: tag, stackTrace: stackTrace);
    if (Get.isRegistered<EasyLogConsoleController>()) {
      Get.find<EasyLogConsoleController>()
          .logs
          .add("[$tag] ${DateTime.now()} $value");
    }
  }
}

void logDebug(dynamic message) {
  _log("DEBUG", message);
}

void logInfo(dynamic message) {
  _log("INFO", message);
}

void logWarning(dynamic message) {
  _log("WARNING", message);
}

void logError(dynamic message) {
  _log("ERROR", message, stackTrace: StackTrace.current);
}

void logWTF(dynamic message) {
  _log("WTF", message, stackTrace: StackTrace.current);
}

void logRequest(RequestOptions options) {
  var string = """
\n->->->->->->->->->->Request->->->->->->->->->
[URL] ${options.uri}
[Method]		 ${options.method}
[ConnectTimeout] ${options.connectTimeout}
[ReceiveTimeout] ${options.receiveTimeout}
[FollowRedirects] ${options.followRedirects}
""";
  if (!options.headers.isEmptyOrNull) {
    string += """
[Header]
${jsonEncode(options.headers)}
""";
  }
  if (!options.extra.isEmptyOrNull) {
    string += """
[Extra]
${jsonEncode(options.extra)}
""";
  }
  if (options.data != null) {
    string += """
[Body]
${options.data is Map ? jsonEncode(options.data) : options.data}
""";
  }
  string += "->->->->->->->->->->Request->->->->->->->->->";
  logInfo(string);
}

void logResponse(Result result) {
  if (result.error != null) {
    logWarning("""
\n->->->->->->->->->->Response->->->->->->->->->
[URL] ${result.response?.requestOptions.uri}
----------------------${result.response?.statusCode}------------------->
[Error] ${result.error}: ${result.message}
->->->->->->->->->->Response->->->->->->->->->
""");
    return;
  }
  var string = """
\n->->->->->->->->->->Response->->->->->->->->->
[URL] ${result.response?.requestOptions.uri}
[Method]		 ${result.response?.requestOptions.method}
[ConnectTimeout] ${result.response?.requestOptions.connectTimeout}
[ReceiveTimeout] ${result.response?.requestOptions.receiveTimeout}
[FollowRedirects] ${result.response?.requestOptions.followRedirects}
""";
  if (result.response?.requestOptions.headers != null &&
      !result.response!.requestOptions.headers.isEmptyOrNull) {
    string += """
[Header]
${jsonEncode(result.response?.requestOptions.headers)}
""";
  }
  if (result.response?.requestOptions.extra != null &&
      !result.response!.requestOptions.extra.isEmptyOrNull) {
    string += """
[Extra]
${jsonEncode(result.response?.requestOptions.extra)}
""";
  }
  if (result.response?.requestOptions.data != null) {
    string += """
[Body]
${result.response?.requestOptions.data is Map ? jsonEncode(result.response?.requestOptions.data) : result.response?.requestOptions.data}
""";
  }
  string +=
      "----------------------${result.response?.statusCode}------------------->";
  if (result.response?.headers != null &&
      !result.response!.headers.isEmptyOrNull) {
    string += """
\n[Header]
${result.response?.headers}
""";
  }
  if (result.response?.extra != null && !result.response!.extra.isEmptyOrNull) {
    string += """
[Extra]
${jsonEncode(result.response?.extra)}
""";
  }
  if (result.response?.data != null) {
    string += """
[Data]
${result.response?.data is Map ? jsonEncode(result.response?.data) : result.response?.data}
""";
  }
  string += "->->->->->->->->->->Response->->->->->->->->->";
  logInfo(string);
}

class EasyLogConsoleController extends GetxController {
  final scrollController = ScrollController();

  /// 所有的日志
  var logs = [].obs;

  /// 在最下面标志
  var followBottom = true.obs;

  /// 自动滚动
  var flowchart = true.obs;

  @override
  void onInit() {
    scrollController.addListener(() {
      updateFollowBottom();
    });
    ever(logs, (value) {
      0.25.seconds.delay(() {
        scrollToBottom();
      });
    });
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void updateFollowBottom() {
    if (scrollController.hasClients) {
      var scrolledToBottom =
          scrollController.offset >= scrollController.position.maxScrollExtent;
      followBottom.value = scrolledToBottom;
    }
  }

  void scrollToBottom() {
    if (scrollController.hasClients && flowchart.value) {
      followBottom.value = true;

      var scrollPosition = scrollController.position;
      scrollController.jumpTo(scrollPosition.maxScrollExtent);
      // scrollController.animateTo(
      //   scrollPosition.maxScrollExtent,
      //   duration: new Duration(milliseconds: 400),
      //   curve: Curves.easeOut,
      // );
    }
  }
}

class EasyLogConsolePage extends StatelessWidget {
  final EasyLogConsoleController controller =
      Get.put(EasyLogConsoleController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        leading: IconButton(
          icon: Icon(
            Icons.developer_mode,
          ),
          onPressed: () {
            if (!isAppDebugFlag) {
              return;
            }
            showSelectBaseURLTypeAlert().then((success) {
              if (success != null && success) {
                if (baseURLChangedCallback != null) {
                  baseURLChangedCallback!();
                }
              }
            });
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              CupertinoIcons.bin_xmark,
            ),
            onPressed: () {
              controller.logs.clear();
            },
          ),
          IconButton(
            icon: Obx(() {
              return Icon(
                controller.flowchart.value
                    ? CupertinoIcons.flowchart_fill
                    : CupertinoIcons.flowchart,
              );
            }),
            onPressed: () {
              controller.flowchart.toggle();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          return ListView.separated(
            controller: controller.scrollController,
            padding: EdgeInsets.symmetric(vertical: 15),
            itemBuilder: (context, index) {
              var log = controller.logs[index];
              return Container(
                alignment: Alignment.centerLeft,
                child: BaseButton(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    log,
                  ),
                  onPressed: () {
                    setClipboard(log);
                  },
                ),
              );
            },
            itemCount: controller.logs.length,
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                height: 1,
                color: colorWithHex9,
              );
            },
          );
        }),
      ),
      floatingActionButton: Obx(() {
        return AnimatedOpacity(
          opacity: controller.followBottom.value ? 0 : 1,
          duration: Duration(milliseconds: 150),
          child: Padding(
            padding: EdgeInsets.only(bottom: 60),
            child: FloatingActionButton(
              mini: true,
              clipBehavior: Clip.antiAlias,
              child: Icon(Icons.arrow_downward),
              backgroundColor: appTheme(context).primaryColor,
              onPressed: controller.scrollToBottom,
            ),
          ),
        );
      }),
    );
  }
}
