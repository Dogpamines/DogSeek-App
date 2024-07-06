import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import 'location.dart';

late SharedPreferences prefs;

class Emergency2 extends StatefulWidget {
  const Emergency2({super.key});

  @override
  State<Emergency2> createState() => _EmergencyState();
}

class _EmergencyState extends State<Emergency2> {
  Map<String, dynamic>? data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 82.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: Text(
                  'Location',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/icon_location.png'),
                  Locate()
                ],
              )
            ],
          ),
        ),
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
            var data = snapshot.data as Map<String, dynamic>;
            return buildBody(data);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () async {
          prefs = await SharedPreferences.getInstance();
          double? lat = prefs.getDouble('lat');
          double? lng = prefs.getDouble('lng');
          print(lat);
          print(lng);

          String url = 'https://dapi.kakao.com/v2/local/search/keyword';
          String api = '';
          String requestUrl = url +
              '.json?y=$lat&x=$lng&query=24시'
                  ' 동물병원&sort=distance';
          print(requestUrl);

          var response = await http.get(
            Uri.parse(requestUrl),
            headers: {"Authorization": "KakaoAK $api"},
            // var url = '';
          );
          print(response);
          var jsonObject = await jsonDecode(response.body);
          print(jsonObject);
          print(jsonObject['documents']);
          print('check');
          print(jsonObject['documents'][0]);

          final address =
              Uri.parse('tel:${jsonObject['documents'][0]['phone']}');
          if (await canLaunchUrl(address)) {
            await launchUrl(address);
          } else {
            print("Can't launch $url");
          }
        },
        child: Icon(
          Icons.emergency,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> getJsonData() async {
    String jsonString =
        await rootBundle.loadString('assets/data/hospitalData.json');
    final jsonResponse = json.decode(jsonString);

    if (jsonResponse is List) {
      return jsonResponse[0] as Map<String, dynamic>;
    } else {
      return jsonResponse as Map<String, dynamic>;
    }
  }

  Widget buildBody(Map<String, dynamic> data) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0), // 좌우 여백 추가
      child: Column(
        children: [
          SizedBox(height: 170),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '가장 가까운 동물 병원',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data['bplcnm'],
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
              ),
              SizedBox(width: 5), // 병원 이름과 "동물병원" 사이에 간격 추가
              Text(
                '동물병원',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data['rdnwhladdr'],
                style: TextStyle(fontSize: 14, color: Colors.grey),
              )
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(right: 5),
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(7)),
                child: Text(
                  '진료중',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                  ),
                ),
              ),
              Text(
                '${data['openhour']} ~ ${data['closehour']}',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              )
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data['sitetel'],
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.lightBlueAccent,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.lightBlueAccent),
              )
            ],
          ),
          SizedBox(height: 30),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: Size(150, 150),
                    shape: CircleBorder()),
                onPressed: () async {
                  final url = Uri.parse('tel:${data['sitetel']}');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    print("Can't launch $url");
                  }
                },
                child: Image.asset('assets/images/icon_call.png'),
              )
            ],
          )
        ],
      ),
    );
  }
}
