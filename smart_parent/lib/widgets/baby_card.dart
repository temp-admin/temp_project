import 'package:flutter/material.dart';

class BabyCardWidget extends StatelessWidget {
  final Map<dynamic, dynamic> userInfo;

  BabyCardWidget({Key? key, required this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              height: 200,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/baby_temp.png'),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(child: Text("이름 : ${userInfo['email']}")),
                      // Icon(genderIcon),
                      // Text(DateFormat('yyyy-MM-dd').format("2023-01-02")),
                    ],
                  ),
                  Text('태어난 지 23일'),
                  Text('별자리: 양자리'),
                  Text('띠: 닭띠'),
                  Text('건강 상태: 양호'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
