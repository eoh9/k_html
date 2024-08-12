import 'package:ai_assistant/screen/SurveyPage.dart';
import 'package:ai_assistant/screen/SurveyPage.dart';
import 'package:ai_assistant/screen/splash_screen2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'apis/app_write.dart';
import 'helper/ad_helper.dart';
import 'helper/global.dart';
import 'helper/pref.dart';

// 전역 변수로 선언
late InAppLocalhostServer localhostServer;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 로컬 서버 시작
  localhostServer = InAppLocalhostServer();
  await localhostServer.start();

  // Init Hive (로컬 저장소)
  await Hive.initFlutter();
  await Hive.openBox('surveyBox');
  await Hive.openBox('selectedServicesBox');

  // Init preferences
  await Pref.initialize();

  // For app write initialization
  AppWrite.init();

  // For initializing Facebook ads SDK
  AdHelper.init();

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      themeMode: Pref.defaultTheme,
      // Dark 모드일 때 기본 설정
      darkTheme: ThemeData(
          useMaterial3: false,
          brightness: Brightness.dark,
          appBarTheme: const AppBarTheme(
            elevation: 1,
            centerTitle: true,
            titleTextStyle:
            TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          )),
      // Light 모드일 때 기본 설정
      theme: ThemeData(
          useMaterial3: false,
          appBarTheme: const AppBarTheme(
            elevation: 1,
            centerTitle: true,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.blue),
            titleTextStyle: TextStyle(
                color: Colors.blue, fontSize: 20, fontWeight: FontWeight.w500),
          )),
      home: const SplashScreen2(), // SplashScreen2를 초기 화면으로 설정
    );
  }
}

extension AppTheme on ThemeData {
  // Light text color
  Color get lightTextColor =>
      brightness == Brightness.dark ? Colors.white70 : Colors.black54;

  // Button color
  Color get buttonColor =>
      brightness == Brightness.dark ? Colors.cyan.withOpacity(.5) : Colors.blue;
}
