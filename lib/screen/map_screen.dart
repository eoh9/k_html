import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized(); // 필요한 호출 추가
    WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kakao Map'),
      ),
      body: WebView(
        initialUrl: 'assets/kakao_map.html', // 로컬 HTML 파일 경로
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController controller) {
          _controller = controller;
        },
        onPageFinished: (String url) {
          // 페이지가 로드된 후 추가 작업 가능
        },
      ),
    );
  }
}
