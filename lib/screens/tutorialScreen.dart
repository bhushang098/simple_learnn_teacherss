import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TutorialScreen extends StatefulWidget {
  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutorial'),
      ),
      body: WebView(
        initialUrl: 'https://www.google.com',
        onWebViewCreated: (WebViewController webViewController) {
          if (!_controller.isCompleted) {
            Text('Loading....');
          }
          _controller.complete(webViewController);
        },
      ),
    );
  }
}
