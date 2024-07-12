import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase Core 패키지 import

import 'firstScreen.dart';
import 'memo.dart';
import 'memoDetail.dart';
import 'newMemo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();

  dotenv.env['naver_map_api'];

  String mapId = dotenv.get('naver_map_api');
  await NaverMapSdk.instance.initialize(
    clientId: mapId,
    onAuthFailed: (ex) {
      debugPrint("********** 네이버맵 인증오류 : $ex **********");
    },
  );

  await Future.delayed(const Duration(seconds: 2));
  FlutterNativeSplash.remove();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => FirstScreen(),
        '/memo': (context) => Memo(),
        '/memoDetail': (context) => MemoDetail(),
        '/newMemo': (context) => NewMemo(),
      },
    );
  }
}
