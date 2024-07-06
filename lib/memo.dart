import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'location.dart';

late SharedPreferences prefs;

class Memo extends StatefulWidget {
  const Memo({super.key});

  @override
  State<Memo> createState() => _MemoState();
}

class _MemoState extends State<Memo> {
  final dio = Dio();

  final url = 'http://10.0.2.2:8080/mydog';
  List? list;

  @override
  void initState() {
    super.initState();
    list = new List.empty(growable: true);
  }

  Future<List?> _asyncList() async {
    prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('identifier');
    Map<String, String> reqHeader = {
      'identifier': prefs.getString('identifier') ?? ''
    };
    final response = await dio.get(url, options: Options(headers: reqHeader));

    if (id == null) {
      prefs.setString("identifier", response.headers['identifier']![0]);
    }

    setState(() {
      list = response.data['list'];
    });

    return list;
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
          ),
        ],
      ),
      body: FutureBuilder(
        future: _asyncList(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text(
              'Error: ${snapshot.error}',
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.only(
                    left: 30,
                    right: 30,
                    bottom: 15,
                  ),
                  child: InkWell(
                    child: Ink(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      height: 80.0,
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 5,
                          left: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${snapshot.data?[index]['myDogDate']}',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xffA3AF9E),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${snapshot.data?[index]['myDogLocation']}',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xff404A3C),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${snapshot.data?[index]['myDogMemo']}',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xff404A3C),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      if (list?[index]['myDogCode'] != 0) {
                        Navigator.of(context).pushNamed('/memoDetail',
                            arguments: list?[index]['myDogCode']);
                      }
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context).pushNamed('/newMemo',
              arguments: prefs.getString("position").toString());
          // String testUrl = 'http://10.0.2.2:8080/mydog/header';
          // Map<String, String> headers = {'test': 'test'};
          //
          // var response = await dio.get(testUrl,
          //     queryParameters: headers,
          //     options: Options(
          //       headers: headers,
          //     ));
          // print(response.headers);
          // print(response.headers['return']?[0]);
          // print(response.headers['date']);
          // print(response.headers['id']?[0]);
          // print(response.data);
        },
        backgroundColor: Color(0xffFFFFFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Image.asset('assets/images/vector_write.png'),
      ),
    );
  }
}
