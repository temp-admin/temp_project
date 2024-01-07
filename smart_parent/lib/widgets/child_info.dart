import 'package:flutter/material.dart';

class ChildInfoWidget extends StatelessWidget {
  final String childName = '아이 이름';
  final double weight = 10.5;
  final String weightDate = '2023-12-01';
  final double temperature = 36.5;
  final String temperatureDate = '2023-12-02';
  final String lastMealDate = '2023-12-02';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.child_care, size: 50),
              Text(childName),
            ],
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('몸무게: $weight kg ($weightDate)'),
                Text('체온: $temperature°C ($temperatureDate)'),
                Text('최근 식사: $lastMealDate'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
