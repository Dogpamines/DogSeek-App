import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'emergency2.dart';
import 'location.dart';
import 'searchHospital.dart';
import 'mapMain.dart';
import 'emergency.dart';
import 'memo.dart';
import 'dict.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Pretendard'),
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Column(
              children: [
                Text(
                  'Location',
                  style: TextStyle(fontSize: 12),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/icon_location.png'),
                    Locate(),
                  ],
                )
              ],
            ),
          ),
          body: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Dict()),
                        );
                      },
                      child: Container(
                        width: 200,
                        height: 229,
                        margin: EdgeInsets.all(0),
                        alignment: Alignment(0.58, 0.8),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('assets/images/myrecord.png'),
                        )),
                        child: Text(
                          "병원기록",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchHospital()),
                        );
                      },
                      child: Container(
                        width: 200,
                        height: 344.5,
                        alignment: Alignment(-0.45, 0.8),
                        margin: EdgeInsets.all(0),
                        child: Text(
                          "병원검색",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('assets/images/hospitalsearch.png'),
                        )),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MapMain()),
                        );
                      },
                      child: Container(
                        width: 200,
                        height: 344.5,
                        alignment: Alignment(-0.15, 0.83),
                        margin: EdgeInsets.all(0),
                        child: Text(
                          "가까운 병원 검색",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff63C54A)),
                        ),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('assets/images/nearhospital.png'),
                        )),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Emergency2()),
                        );
                      },
                      child: Container(
                        width: 200,
                        height: 229,
                        alignment: Alignment(-0.42, 0.68),
                        margin: EdgeInsets.all(0),
                        child: Text(
                          "응급 상황",
                          style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('assets/images/emergency.png'),
                        )),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
