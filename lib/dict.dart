import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'location.dart';

class Dict extends StatefulWidget {
  const Dict({super.key});

  @override
  State<Dict> createState() => _DictState();
}

class _DictState extends State<Dict> {
  final dio = Dio();

  Future<Map<String, dynamic>> fetchDogs() async {
    final response = await dio.get('http://localhost:8080/dict');
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load dogs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
                Image.asset('assets/images/icon_location.png'),
                Locate(),
              ],
            )
          ],
        ),
        actions: [
          SizedBox(
            width: 60,
          )
        ],
      ),
    );
  }
}
