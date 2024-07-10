import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'location.dart';

class ProductDetail extends StatelessWidget {
  final String product;

  const ProductDetail({super.key, required this.product});

  Future<Map<String, dynamic>> fetchProductDetails(int prodCode) async {
    try {
      final response = await Dio().get(
        'http://10.0.2.2:8080/products/$prodCode',
        options: Options(
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load dog details');
      }
    } catch (e) {
      throw Exception('Failed to load dog details: $e');
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final int prodCode = int.tryParse(product) ?? 0;
    final formatCurrency = new NumberFormat.simpleCurrency(
        locale: "ko_KR", name: "₩", decimalDigits: 0);
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
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchProductDetails(prodCode),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var prodDetails = snapshot.data!['product'];
            return Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.network(
                      prodDetails['prodImage'],
                      width: 500,
                    ),
                    Container(
                      width: 300,
                      child: Text(
                        '제품명 : ${prodDetails['prodName']}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: 300,
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        '제조사 : ${prodDetails['prodManufac']}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: 300,
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        '가격 : ${formatCurrency.format(prodDetails['prodPrice'])}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: 300,
                      margin: EdgeInsets.only(top: 10),
                      child: () {
                        switch (prodDetails['prodGrade']) {
                          case 5:
                            return Row(
                              children: [
                                Container(
                                  child: Text(
                                    '평점 : ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  child: Image.asset('assets/images/5star.png'),
                                )
                              ],
                            );
                          case 4:
                            return Image.asset('assets/images/4star.png');
                          case 3:
                            return Image.asset('assets/images/3star.png');
                          case 2:
                            return Image.asset('assets/images/2star.png');
                          case 1:
                            return Image.asset('assets/images/1star.png');
                        }
                      }(),
                    ),
                    Container(
                      width: 300,
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        '제품기능 : ${prodDetails['prodEffi']}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: 300,
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        '추천견종 : ${prodDetails['prodRecom']}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: 300,
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        '조리방식 : ${prodDetails['prodCook']}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: 300,
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        '입자크기 : ${prodDetails['prodSize']}mm',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: 300,
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        '재료 : ${prodDetails['prodIngra']}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 55, bottom: 40),
                          child: Text(
                            '사이트주소 : ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          width: 245,
                          margin: EdgeInsets.only(top: 5),
                          child: GestureDetector(
                            onTap: () {
                              _launchURL(prodDetails['prodSite']);
                            },
                            child: Text(
                              '${prodDetails['prodSite']}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('No data found'));
          }
        },
      ),
    );
  }
}
