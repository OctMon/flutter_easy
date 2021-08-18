import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

import 'global_util.dart';

void _log(String tag, dynamic value, {StackTrace? stackTrace}) {
  if (isDebug || isAppDebugFlag) {
    developer.log("${DateTime.now()} $value",
        time: DateTime.now(), name: tag, stackTrace: stackTrace);
    final EasyLogConsoleController controller =
        Get.put(EasyLogConsoleController());
    controller.logs.add("[$tag] ${DateTime.now()} $value\n");
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
[ConnectTimeout] ${options.connectTimeout / 1000}
[ReceiveTimeout] ${options.receiveTimeout / 1000}
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
[ConnectTimeout] ${(result.response?.requestOptions.connectTimeout ?? 0) / 1000}
[ReceiveTimeout] ${(result.response?.requestOptions.receiveTimeout ?? 0) / 1000}
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

  var logs = [].obs;
  var followBottom = true.obs;

  @override
  void onInit() {
    scrollController.addListener(() {
      updateFollowBottom();
    });
    ever(logs, (value) {
      scrollToBottom();
    });
    super.onInit();
  }

  void updateFollowBottom() {
    if (scrollController.hasClients) {
      var scrolledToBottom =
          scrollController.offset >= scrollController.position.maxScrollExtent;
      followBottom.value = scrolledToBottom;
    }
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      followBottom.value = true;

      var scrollPosition = scrollController.position;
      scrollController.animateTo(
        scrollPosition.maxScrollExtent,
        duration: new Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  }
}

class EasyLogConsolePage extends StatelessWidget {
  final EasyLogConsoleController controller =
      Get.put(EasyLogConsoleController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: Colors.black,
      appBar: BaseAppBar(
        backgroundColor: Colors.grey[900],
        leading: IconButton(
          icon: Icon(
            Icons.developer_mode,
            color: Colors.white,
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
      ),
      body: Obx(() {
        return ListView.builder(
          controller: controller.scrollController,
          padding: EdgeInsets.symmetric(horizontal: 15),
          itemBuilder: (context, index) {
            var log = controller.logs[index];
            return BaseTitle(
              log,
              color: Colors.white,
            );
          },
          itemCount: controller.logs.length,
        );
      }),
      floatingActionButton: Obx(() {
        return AnimatedOpacity(
          opacity: controller.followBottom.value ? 0 : 1,
          duration: Duration(milliseconds: 150),
          child: Padding(
            padding: EdgeInsets.only(bottom: 60),
            child: FloatingActionButton(
              mini: true,
              clipBehavior: Clip.antiAlias,
              child: Icon(
                Icons.arrow_downward,
                color: Colors.white,
              ),
              onPressed: controller.scrollToBottom,
            ),
          ),
        );
      }),
    );
  }
}
