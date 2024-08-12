import 'package:flutter/material.dart';
import 'SurveyPage.dart'; // SurveyPage의 경로를 맞추세요.

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({Key? key}) : super(key: key);

  @override
  _SplashScreen2State createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {
  @override
  void initState() {
    super.initState();
    _navigateToSurveyPage();
  }

  _navigateToSurveyPage() async {
    await Future.delayed(const Duration(seconds: 2), () {}); // 2초간 대기
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SurveyPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        'assets/images/loading_page.png', // 이미지 경로를 맞추세요.
        fit: BoxFit.cover, // 이미지를 화면에 꽉 채우도록 설정
        width: double.infinity, // 이미지의 가로 너비를 화면에 맞춤
        height: double.infinity, // 이미지의 세로 높이를 화면에 맞춤
      ),
    );
  }
}
