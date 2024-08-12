import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  InAppWebViewController? webViewController;
  String url = "http://localhost:8080/assets/web/kakaomap.html";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('카카오맵'),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(url)),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            useShouldOverrideUrlLoading: true,
            mediaPlaybackRequiresUserGesture: false,
          ),
        ),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onLoadStop: (controller, url) async {
          // 지도가 로드된 후 필요한 JavaScript 실행
          await controller.evaluateJavascript(source: """
            // 여기에 카카오맵 초기화 코드나 다른 필요한 JavaScript 코드를 추가하세요
          """);
        },
        onLoadError: (controller, url, code, message) {
          print('WebView 로드 오류: $code, $message');
        },
        onConsoleMessage: (controller, consoleMessage) {
          print('콘솔 메시지: ${consoleMessage.message}');
        },
      ),
    );
  }
}