import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'firstScreen.dart';
import 'memo.dart';
import 'memoDetail.dart';
import 'newMemo.dart';

late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

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

  prefs = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool isOnboarded = prefs.getBool('isOnboarded') ?? false;

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
