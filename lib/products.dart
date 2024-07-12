import 'package:dio/dio.dart';
import 'package:dogsick_project/productDetail.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'location.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final Dio dio = Dio();
  List<dynamic> _products = [];
  List<dynamic> _filteredProducts = [];
  bool _isLoading = true;
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _getToken();
    _intFirebaseMessaging(context);
  }

  Future<void> _fetchProducts() async {
    try {
      final response = await dio.get('http://10.0.2.2:8080/products');
      if (response.statusCode == 200) {
        setState(() {
          _products = response.data['products'];
          _filteredProducts = _products;
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
        _filteredProducts = _products;
      } else {
        _filteredProducts = _products.where((products) {
          return products['prodName']
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
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(99, 197, 74, 100)),
                      borderRadius: BorderRadius.circular(30)),
                  hintText: '견종을 입력 해주세요!',
                  hintStyle: TextStyle(
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(99, 197, 74, 100)),
                    borderRadius: BorderRadius.circular(30),
                  )),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _filteredProducts.isEmpty
              ? Center(child: Text('검색 결과가 없어요'))
              : ListView.builder(
                  itemCount: _filteredProducts.length,
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
                                        builder: (context) => ProductDetail(
                                          product: _filteredProducts[index]
                                                  ['prodCode']
                                              .toString(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    _filteredProducts[index]['prodName']
                                        .toString(),
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

_getToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  print("message.getToken(), ${await messaging.getToken()}");
}

_intFirebaseMessaging(BuildContext context) {
  FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    // 메시지 제목 출력
    print(event.notification!.title);
    // 메시지 본문 출력
    print(event.notification!.body);
    // 다이얼로그를 화면에 띄움
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // 다이얼로그 위젯
          return AlertDialog(
            title: Text('알림'),
            content: Text(event.notification!.body!),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Ok'),
              )
            ],
          );
        });
  });
}
