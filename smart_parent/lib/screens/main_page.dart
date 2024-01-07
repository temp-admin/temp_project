import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/baby_card.dart';
import '../widgets/blur_overlay.dart';
import 'dart:convert';
import '../http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Map<String, dynamic> userInfo = {};
  bool showBlurOverlay = false;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  void _getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('jwtToken') ?? '';

    final response = await httpClient.get(
      Uri.parse('http://192.168.3.3:3000/current-user'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      final fetchedUserInfo = json.decode(response.body);

      setState(() {
        userInfo = fetchedUserInfo;
        showBlurOverlay = (userInfo['children'] ?? 0) == 0;
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Image.asset('assets/logo.png', fit: BoxFit.contain, height: 30),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              setState(() {
                showBlurOverlay = !showBlurOverlay;
              });
            },
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              BabyCardWidget(userInfo: userInfo),
              Expanded(child: Text("이름 : ${userInfo['email']}")),
            ],
          ),
          if (showBlurOverlay) BlurOverlay(),
        ],
      ),
    );
  }
}
