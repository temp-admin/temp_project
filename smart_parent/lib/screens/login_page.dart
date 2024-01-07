import 'package:flutter/material.dart';
import 'signup_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'main_page.dart';
import 'dart:convert';
import '../http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  String _email = '';
  String _password = '';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    void main() {
      runApp(MaterialApp(
        home: LoginPage(),
        navigatorKey: navigatorKey,
      ));
    }

    Future<void> _storeToken(String token) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwtToken', token);
    }

    Future<void> _login(BuildContext context) async {
      final response = await httpClient.post(
        Uri.parse('http://192.168.3.3:3000/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final String token = responseData['token'];

        await _storeToken(token);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      } else {}
    }

    // Future<void> _login(BuildContext context) async {
    //   final response = await httpClient.post(
    //     Uri.parse('http://192.168.3.3:3000/login'),
    //     headers: {'Content-Type': 'application/json'},
    //     body: json.encode({
    //       'email': _emailController.text,
    //       'password': _passwordController.text,
    //     }),
    //   );
    //   if (response.headers.containsKey('set-cookie')) {
    //     savedCookie = response.headers['set-cookie'];
    //   }
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => MainPage()),
    //   );
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text("로그인"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  child: Image.asset('assets/logo.png', fit: BoxFit.contain),
                ),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: '아이디',
                  border: OutlineInputBorder(),
                ),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => _login(context),
                child: Text(AppLocalizations.of(context)!.login),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                child: const Text('회원가입'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
