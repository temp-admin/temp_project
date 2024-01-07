import 'package:flutter/material.dart';

class EmailVerificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('이메일 인증')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '회원가입이 거의 완료되었습니다. 제공하신 이메일로 인증 메일이 발송되었습니다. 이메일을 확인하여 계정을 활성화해주세요.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('이메일 확인 완료'),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
