import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:webview_flutter/webview_flutter.dart';

Future<T?>? toWebViewUrl<T>(String url,
    {bool preventDuplicates = false}) async {
  return toNamed(routesWebNamed,
      arguments: {"url": url}, preventDuplicates: preventDuplicates);
}

Future<T?>? toWebViewHtml<T>(String html,
    {bool preventDuplicates = false}) async {
  return toNamed(routesWebNamed,
      arguments: {"html": html}, preventDuplicates: preventDuplicates);
}

class BaseWebController extends GetxController {
  final title = "".obs;
}

class BaseWebPage extends StatelessWidget {
  final String? url;
  final String? html;
  BaseWebPage({super.key, this.url, this.html});

  final controller = Get.put(BaseWebController());

  final webController = WebViewController();

  @override
  Widget build(BuildContext context) {
    final String? url = this.url ?? Get.arguments?["url"];
    final String? html = this.html ?? Get.arguments?["html"];

    /// 获取当前加载页面的 title
    Future<void> loadTitle() async {
      final String temp = (await webController.getTitle()) ?? "";
      controller.title.value = temp;
      logDebug('title: $temp');
    }

    webController
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
      webController.loadHtmlString(html);
    } else if (url != null) {
      webController.loadRequest(Uri.parse(url));
    }

    return BaseScaffold(
      appBar: BaseAppBar(
        title: Obx(() {
          return Text(controller.title.value);
        }),
      ),
      body: Builder(builder: (BuildContext context) {
        return WebViewWidget(controller: webController);
      }),
    );
  }
}
