import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import 'location.dart';

class Emergency extends StatefulWidget {
  const Emergency({super.key});

  @override
  State<Emergency> createState() => _EmergencyState();
}

class _EmergencyState extends State<Emergency> {
  Map<String, dynamic>? _map;
  Map<String, dynamic>? data;

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
        future: fetchDataAndJson(),
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
    );
  }

  Future<Map<String, dynamic>> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? lat = prefs.getDouble('lat');
    double? lng = prefs.getDouble('lng');
    print(lat);
    print(lng);

    String url = 'https://dapi.kakao.com/v2/local/search/keyword';
    String api = '';
    String requestUrl = '$url.json?y=$lat&x=$lng&query=24시 동물병원&sort=distance';

    final response = await http.get(
      Uri.parse(requestUrl),
      headers: {"Authorization": "KakaoAK $api"},
    );

    if (response.statusCode == 200) {
      var jsonObject = jsonDecode(response.body);
      return jsonObject['documents'][0];
    } else {
      throw Exception("Failed to load data: ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>> getJsonData() async {
    String jsonString =
        await rootBundle.loadString('assets/data/hospitalData.json');
    final jsonResponse = json.decode(jsonString);

    if (jsonResponse is List) {
      var filteredList =
          jsonResponse.where((item) => item['openhour'] == '00:00').toList();
      if (filteredList.isNotEmpty) {
        return filteredList[0] as Map<String, dynamic>;
      } else {
        throw Exception('가까운 24시 병원이 없습니다.');
      }
    } else if (jsonResponse is Map<String, dynamic> &&
        jsonResponse['openhour'] == '00:00') {
      return jsonResponse;
    } else {
      throw Exception('가까운 24시 병원이 없습니다.');
    }
  }

  Future<Map<String, dynamic>> fetchDataAndJson() async {
    try {
      final dataFromFetchData = await fetchData();
      final dataFromJson = await getJsonData();
      // 두 개의 데이터를 병합하여 하나의 맵으로 반환합니다.
      return {
        'dataFromFetchData': dataFromFetchData,
        'dataFromJson': dataFromJson,
      };
    } catch (e) {
      throw Exception('Failed to fetch data from both sources');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDataAndJson();
  }

  Widget buildBody(Map<String, dynamic> addData) {
    final dataFromFetchData = addData['dataFromFetchData'];
    final dataFromJson = addData['dataFromJson'];
    return Container(
      color: Colors.white,
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
                dataFromFetchData['place_name'] ?? 'Unknown',
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
                dataFromFetchData['road_address_name'] ?? 'Unknown',
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
                '${dataFromJson['openhour']} ~ ${dataFromJson['closehour']}',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              )
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                dataFromFetchData['phone'] ?? 'Unknown',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.lightBlueAccent,
                    // decoration: TextDecoration.underline,
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
                  final url = Uri.parse('tel:${dataFromFetchData['phone']}');
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
