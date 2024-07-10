import 'dart:convert';
import 'dart:io';

import 'package:dogsick_project/mapMain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'location.dart';

class HospitalDetail extends StatelessWidget {
  final String bplcnm;

  const HospitalDetail({super.key, required this.bplcnm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: BackButton(
          color: Color(0xff63C54A),
        ),
        title: Column(
          children: [
            Text(
              'Location',
              style: TextStyle(fontSize: 12),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/Location.png'),
                Locate(),
              ],
            )
          ],
        ),
        actions: [
          SizedBox(
            width: 60,
          ),
        ],
      ),
      body: FutureBuilder(
        future: getJsonData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          } else {
            var data = snapshot.data as List<dynamic>;
            var hospital = data.firstWhere(
                (element) => element['bplcnm'] == bplcnm,
                orElse: () => null);
            if (hospital == null) {
              return Center(child: Text('병원을 찾을 수 없습니다'));
            } else {
              return buildBody(hospital);
            }
          }
        },
      ),
    );
  }

  Future<List<dynamic>> getJsonData() async {
    String jsonString =
        await rootBundle.loadString('assets/data/hospitalData.json');
    final jsonResponse = json.decode(jsonString);
    return jsonResponse as List<dynamic>;
  }

  Widget buildBody(Map<String, dynamic> hospital) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: [
          Image.network(
            '${hospital['image']}',
            fit: BoxFit.cover,
            height: 500,
            width: 450,
          ),
          Container(
            margin: EdgeInsets.only(top: 410),
            width: 500,
            height: 600,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.white),
            child: Container(
              margin: EdgeInsets.only(top: 20, left: 28),
              child: DefaultTextStyle(
                style: TextStyle(
                  color: Colors.black,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${hospital['bplcnm']}',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            color: Color.fromRGBO(99, 197, 74, 100),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 3),
                            child: Text(
                              '${hospital['sitetel']}',
                              style: TextStyle(color: Colors.lightBlueAccent),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 500,
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Color.fromRGBO(99, 197, 74, 100),
                            ),
                            Container(
                              width: 320,
                              child: Text(
                                '${hospital['sitewhladdr']}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 10),
                          Column(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                size: 50,
                              ),
                              SizedBox(height: 5),
                              Text('예약 가능'),
                            ],
                          ),
                          SizedBox(width: 20),
                          Column(
                            children: [
                              Icon(
                                Icons.time_to_leave,
                                size: 50,
                              ),
                              SizedBox(height: 5),
                              Text('주차 가능'),
                            ],
                          ),
                          SizedBox(width: 20),
                          Column(
                            children: [
                              Icon(Icons.wifi, size: 50),
                              SizedBox(height: 5),
                              Text('와이파이'),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                          '영업 시간: ${hospital['openhour']} ~ ${hospital['closehour']}'),
                      SizedBox(height: 10),
                      Text(
                          '휴무일: ${hospital['closeday'] != 'null' ? hospital['closeday'].toString() : '없음'}'),
                      SizedBox(height: 35),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 50,
                            margin: EdgeInsets.only(right: 18),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff63C54A),
                              ),
                              // 비동기 함수 선언
                              onPressed: () async {
                                final url =
                                    Uri.parse('tel:${hospital['sitetel']}');
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url);
                                } else {
                                  print("Can`t launch $url");
                                }
                              },
                              child: Text(
                                '전화하기',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                        ],
                      )
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
