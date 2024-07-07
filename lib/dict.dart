import 'package:dio/dio.dart';
import 'package:dogsick_project/dogDetail.dart';
import 'package:flutter/material.dart';
import 'location.dart';

class Dict extends StatefulWidget {
  const Dict({super.key});

  @override
  State<Dict> createState() => _DictState();
}

class _DictState extends State<Dict> {
  final Dio dio = Dio();
  List<dynamic> _dogs = [];
  List<dynamic> _filteredDogs = [];
  bool _isLoading = true;
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    _fetchDogs();
  }

  Future<void> _fetchDogs() async {
    try {
      final response = await dio.get('http://10.0.2.2:8080/dict');
      if (response.statusCode == 200) {
        setState(() {
          _dogs = response.data['dict'];
          _filteredDogs = _dogs;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load dogs');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
    }
  }

  void _filterDogs(String query) {
    setState(() {
      _searchText = query;
      if (_searchText.isEmpty) {
        _filteredDogs = _dogs;
      } else {
        _filteredDogs = _dogs.where((dog) {
          return dog['dogName']
              .toString()
              .toLowerCase()
              .contains(_searchText.toLowerCase());
        }).toList();
      }
    });
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Container(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            margin: EdgeInsets.only(top: 10),
            child: TextField(
              onChanged: _filterDogs,
              decoration: InputDecoration(
                hintText: '견종을 입력 해주세요!',
                hintStyle: TextStyle(
                  fontSize: 14,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromRGBO(99, 197, 74, 100)),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _filteredDogs.isEmpty
              ? Center(child: Text('검색 결과가 없어요'))
              : ListView.builder(
                  itemCount: _filteredDogs.length,
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
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DogDetail(
                                          dog: _filteredDogs[index]['dogName']
                                              .toString(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    _filteredDogs[index]['dogName'].toString(),
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    side: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
