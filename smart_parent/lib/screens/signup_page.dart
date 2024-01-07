import 'package:flutter/material.dart';
import 'email_verification_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _phoneNumber = '';

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      _registerUser();
    }
  }

  Future<void> _registerUser() async {
    final url = 'http://192.168.3.3:3000/register';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': _email,
          'password': _password,
          'phoneNumber': _phoneNumber,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => EmailVerificationPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 실패: ${response.body}')),
        );
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('네트워크 오류')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('회원가입')),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return '유효한 이메일 주소를 입력해주세요.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: '이메일',
                    ),
                  ),
                  TextFormField(
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return '비밀번호는 7자 이상이어야 합니다.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: '비밀번호',
                    ),
                  ),
                  // TextFormField(
                  //   key: const ValueKey('confirmPassword'),
                  //   validator: (value) {
                  //     if (value != _password) {
                  //       return '비밀번호가 일치하지 않습니다.';
                  //     }
                  //     return null;
                  //   },
                  //   obscureText: true,
                  //   decoration: const InputDecoration(
                  //     labelText: '비밀번호 확인',
                  //   ),
                  // ),
                  TextFormField(
                    key: const ValueKey('phoneNumber'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '전화번호를 입력해주세요.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _phoneNumber = value!;
                    },
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: '전화번호',
                    ),
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    child: Text('회원가입'),
                    onPressed: _trySubmit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
