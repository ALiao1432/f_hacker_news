import 'dart:async';

import 'package:f_hacker_news/data/model/item.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatelessWidget {
  final Item item;
  final _controllerCompleter = Completer<WebViewController>();
  WebViewController _webViewController;

  WebViewPage(this.item);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              item.url,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
      body: WebView(
        initialUrl: item.url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (webViewController) =>
            _controllerCompleter.complete(webViewController),
      ),
    );
  }
}
