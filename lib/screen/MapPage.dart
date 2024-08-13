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
          controller.addJavaScriptHandler(
              handlerName: 'myFlutterApp',
              callback: (args) {
                if (args.isNotEmpty && args[0] == 'showModal') {
                  String markerId = args[1];
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onVerticalDragUpdate: (details) {
                          int sensitivity = 8;
                          if (details.delta.dy < -sensitivity) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: Container(
                          height: 800,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Stack(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 40, bottom: 10, left: 10, right: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/buttomWid.png'),
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  height: 4.0,
                                  width: 100.0,
                                  color: Colors.black,
                                  margin: EdgeInsets.only(top: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    backgroundColor: Colors.transparent,
                  );
                }
              }
          );
        },
        onLoadStop: (controller, url) async {
          // 페이지 로드가 완료된 후 추가 작업을 할 수 있습니다.
        },
      ),
    );
  }
}
