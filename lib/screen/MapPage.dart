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
          // Set up JavaScript handlers here
          controller.addJavaScriptHandler(handlerName: 'myFlutterApp', callback: (args) {
            if (args.isNotEmpty && args[0] == 'showModal') {
              String markerId = args[1];  // 마커 ID 받기
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 400,
                    margin: const EdgeInsets.only(left: 5, right: 5, bottom: 40),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      image: DecorationImage(
                        image: AssetImage('assets/images/buttomWid.png'), // 이미지 파일
                        fit: BoxFit.cover, // 이미지가 컨테이너를 꽉 채우도록 조정
                      ),
                    ),// 마커 ID를 화면에 표시
                  );
                },
                backgroundColor: Colors.transparent,
              );
            }
          });
        },
        onLoadStop: (controller, url) async {
          // 페이지 로드가 완료된 후 추가 작업을 할 수 있습니다.
        },
      ),
    );
  }
}
