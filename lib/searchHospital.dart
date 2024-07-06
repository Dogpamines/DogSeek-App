import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'location.dart';
import 'hospitalDetail.dart';

class SearchHospital extends StatefulWidget {
  const SearchHospital({super.key});

  @override
  State<SearchHospital> createState() => _SearchAppState();
}

class _SearchAppState extends State<SearchHospital> {
  List<dynamic> data = [];
  List<dynamic> filteredData = [];
  TextEditingController _editingController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  int page = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        page++;
        getJSONData();
      }
    });
    getJSONData(); // 초기 데이터 로드
  }

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
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              width: 315,
              height: 36,
              margin: EdgeInsets.only(left: 50, top: 50, right: 50),
              child: TextField(
                controller: _editingController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(99, 197, 74, 100)),
                      borderRadius: BorderRadius.circular(15)),
                  hintText: '검색할 병원을 입력하세요',
                  hintStyle: TextStyle(
                    fontSize: 12,
                  ),
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(99, 197, 74, 100)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onChanged: (value) {
                  filterData(value);
                },
              ),
            ),
            Expanded(
              child: filteredData.isEmpty
                  ? Center(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 150),
                        child: Text(
                          '검색 결과가 없어요.',
                          style: TextStyle(fontSize: 12, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.only(top: 10),
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      filteredData[index]['bplcnm'].toString(),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Text(
                                        filteredData[index]['lindjobgbnnm']
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 8,
                                          color: Color.fromRGBO(
                                              153, 153, 153, 100),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Text(
                                    filteredData[index]['rdnwhladdr']
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 10,
                                        color:
                                            Color.fromRGBO(153, 153, 153, 100)),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Text(
                                    filteredData[index]['sitetel'].toString(),
                                    style: TextStyle(
                                        fontSize: 10,
                                        color:
                                            Color.fromRGBO(112, 178, 222, 100)),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 3),
                                        child: Icon(
                                          Icons.watch_later,
                                          size: 15,
                                          color:
                                              Color.fromRGBO(99, 197, 74, 100),
                                        ),
                                      ),
                                      Text(
                                        filteredData[index]['openhour']
                                            .toString(),
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        '~',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        filteredData[index]['closehour']
                                            .toString(),
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Text(
                                          '휴무일 : ',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                      Container(
                                        width: 90,
                                        child: Text(
                                          filteredData[index]['closeday'] !=
                                                  'null'
                                              ? filteredData[index]['closeday']
                                                  .toString()
                                              : '없음',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 66),
                                        width: 100,
                                        height: 30,
                                        child: OutlinedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    HospitalDetail(
                                                  bplcnm: filteredData[index]
                                                          ['bplcnm']
                                                      .toString(),
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            '상세보기',
                                            style: TextStyle(
                                                fontSize: 8,
                                                color: Color.fromRGBO(
                                                    99, 197, 74, 100)),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            side: BorderSide(
                                              color: Color.fromRGBO(
                                                  99, 197, 74, 100),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: filteredData.length,
                      controller: _scrollController,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getJSONData() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/data/hospitalData.json');
      final jsonResponse = json.decode(jsonString);
      setState(() {
        data = jsonResponse;
        filterData(_editingController.text);
      });
    } catch (e) {
      print("Error loading JSON: $e");
    }
  }

  void filterData(String query) {
    List<dynamic> results = [];
    if (query.isEmpty) {
      results = data;
    } else {
      results = data.where((item) {
        final name = item['bplcnm'].toString().toLowerCase();
        final queryLower = query.toLowerCase();
        return name.contains(queryLower);
      }).toList();
    }

    setState(() {
      filteredData = results;
    });
  }
}
