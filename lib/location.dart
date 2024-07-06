import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;

class Locate extends StatefulWidget {
  const Locate({super.key});

  @override
  State<Locate> createState() => _LocateState();
}

class _LocateState extends State<Locate> {
  Location location = new Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  double lat = 0;
  double lng = 0;
  String apiUrl = 'https://dapi.kakao.com/v2/local/geo/coord2regioncode';
  String apiKey = '';
  String position = '';

  _locateMe() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    prefs = await SharedPreferences.getInstance();
    position = await prefs.getString("position").toString();
    // print('position: $position');
  }

  Future<String> _locate() async {
    _locateMe();

    await location.getLocation().then((res) {
      if (lat != res.latitude || lng != res.longitude) {
        print('changed');
        setState(() {
          lat = res.latitude!;
          lng = res.longitude!;
          _locateAddress();
        });
      }
    });
    return position;
  }

  _locateAddress() async {
    print('call');

    prefs = await SharedPreferences.getInstance();

    String finalApiUrl = apiUrl +
        '.json?x=' +
        lng.toString() +
        '&y=' +
        lat.toString() +
        '&input_coord=WGS84';

    var response = await http.get(Uri.parse(finalApiUrl),
        headers: {"Authorization": "KakaoAK $apiKey"});
    var jsonObject = await jsonDecode(response.body);
    setState(() {
      position = jsonObject['documents'][0]['region_2depth_name'].toString() +
          ' ' +
          jsonObject['documents'][0]['region_3depth_name'].toString();
      prefs.setString("position", position);
      prefs.setDouble("lat", lat);
      prefs.setDouble("lng", lng);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _locate(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false) {
            return Text(
              '$position',
              style: TextStyle(fontSize: 10),
            );
          } else {
            return Text(
              '${snapshot.data}',
              style: TextStyle(
                fontSize: 10,
              ),
            );
          }
        });
  }
}
