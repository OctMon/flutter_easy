import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:webview_flutter/webview_flutter.dart';

typedef BaseWebViewController = WebViewController;

Future<T?>? toWebViewUrl<T>(
    {required String url,
    BaseWebViewController? webController,
    bool preventDuplicates = false}) async {
  Get.put(BaseWebController(webController: webController, url: url));
  final result =
      await to(() => BaseWebPage(), preventDuplicates: preventDuplicates);
  Get.delete<BaseWebController>();
  return result;
}

Future<T?>? toWebViewHtml<T>(
    {required String html,
    BaseWebViewController? webController,
    bool preventDuplicates = false}) async {
  Get.put(BaseWebController(webController: webController, html: html));
  final result =
      await to(() => BaseWebPage(), preventDuplicates: preventDuplicates);
  Get.delete<BaseWebController>();
  return result;
}

class BaseWebController extends GetxController {
  BaseWebViewController? webController;
  final String? url;
  final String? html;

  BaseWebController({this.webController, this.url, this.html});

  @override
  void onClose() {
    // webController = null;
    // Get.delete<BaseWebController>();
    logDebug("onClose");
    super.onClose();
  }

  @override
  void onInit() {
    if (webController == null) {
      webController ??= WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.transparent)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {
              logDebug('Page started loading: $url');
            },
            onPageFinished: (String url) {
              logDebug('Page finished loading: $url');
              loadTitle();
            },
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              // if (request.url.startsWith('https://www.youtube.com/')) {
              //   return NavigationDecision.prevent;
              // }
              return NavigationDecision.navigate;
            },
          ),
        );
      if (html != null) {
        webController?.loadHtmlString(html!);
      } else if (url != null) {
        webController?.loadRequest(Uri.parse(url!));
      }
    }

    super.onInit();
  }

  final title = "".obs;

  /// 获取当前加载页面的 title
  Future<void> loadTitle() async {
    final String temp = (await webController?.getTitle()) ?? "";
    title.value = temp;
    logDebug('title: $temp');
  }
}

class BaseWebView extends StatelessWidget {
  BaseWebView({super.key, required this.controller});

  final BaseWebViewController controller;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      return WebViewWidget(controller: controller);
    });
  }
}

class BaseWebPage extends StatelessWidget {
  final controller = Get.put(BaseWebController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: Obx(() {
          return Text(controller.title.value);
        }),
      ),
      body: Builder(builder: (BuildContext context) {
        return WebViewWidget(controller: controller.webController!);
      }),
    );
  }
}
