import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'location.dart';

class DogDetail extends StatelessWidget {
  final String dog;

  const DogDetail({super.key, required this.dog});

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
    );
  }
}
