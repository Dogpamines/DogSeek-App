import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;

class NewMemo extends StatefulWidget {
  const NewMemo({super.key});

  @override
  State<NewMemo> createState() => _NewMemoState();
}

class _NewMemoState extends State<NewMemo> {
  final dio = Dio();

  final url = 'http://10.0.2.2:8080/mydog';

  DateTime? _selectedDate;
  TextEditingController? _myDogLocation;
  TextEditingController? _myDogMemo;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _myDogLocation = TextEditingController();
    _myDogMemo = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
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
                Text(
                  '$args',
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
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
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          top: 60,
          // left: 25,
        ),
        child: SizedBox(
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '날짜',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  SizedBox(
                    width: 100,
                    child: Text(
                      _selectedDate != null
                          ? _selectedDate.toString().split(' ')[0]
                          : '날짜를 선택하세요.',
                      style: TextStyle(fontSize: 12, color: Color(0xff999999)),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  SizedBox(
                    width: 60,
                    height: 20,
                    child: ElevatedButton(
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                          helpText: '날짜를 선택하세요',
                          cancelText: '취소',
                          confirmText: '선택',
                        ).then((selectedDate) {
                          setState(() {
                            _selectedDate = selectedDate;
                          });
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff63c54a),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        '날짜 선택',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    '장소',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      undoController: UndoHistoryController(),
                      controller: _myDogLocation,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff999999),
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '동물병원을 입력해주세요',
                        hintStyle: TextStyle(
                          fontSize: 12,
                          color: Color(0xff999999),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '진료 내용',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                width: 300,
                height: 100,
                child: TextField(
                  maxLines: null,
                  controller: _myDogMemo,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xff999999),
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '진료내용을 입력해주세요',
                    hintStyle: TextStyle(
                      fontSize: 12,
                      color: Color(0xff999999),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 110,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff404A3C),
                      ),
                      child: Text(
                        '취소',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  SizedBox(
                    width: 110,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () async {
                        prefs = await SharedPreferences.getInstance();
                        var response = await dio.post(url, data: {
                          'myDogCode': 0,
                          'myDogDate': _selectedDate.toString().split(' ')[0],
                          'myDogLocation': _myDogLocation!.value.text,
                          'myDogMemo': _myDogMemo!.value.text,
                          'myDogId': prefs.getString("identifier")
                        });

                        Navigator.popAndPushNamed(context, '/memoDetail',
                            arguments:
                                response.headers['location']![0].substring(1));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff63C54A),
                      ),
                      child: Text(
                        '등록',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
