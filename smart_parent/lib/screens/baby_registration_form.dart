import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../http_client.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'main_page.dart';

class BabyRegistrationForm extends StatefulWidget {
  @override
  _BabyRegistrationFormState createState() => _BabyRegistrationFormState();
}

class _BabyRegistrationFormState extends State<BabyRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  DateTime? _birthdate;
  XFile? _image;
  String? _selectedGender;
  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _birthdate = picked;
      });
    }
  }

  void _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  Future<void> uploadImage(XFile? imageFile) async {
    var uri = Uri.parse('http://192.168.3.3:3000/api/upload/image');
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('jwtToken') ?? '';
    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image uploaded successfully.');
    } else {
      print('Image upload failed.');
    }
  }

  void _submitForm() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('jwtToken') ?? '';
      var url = Uri.parse('http://192.168.3.3:3000/addbabyinfo');

      var response = await httpClient.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode({
          "name": _nameController.text,
          "gender": _selectedGender,
          "birthdate": _birthdate?.toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        print('Data successfully sent to the server');
        await uploadImage(_image);
        if (response.statusCode == 200) {
          if (mounted) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('성공'),
                  content: Text('아기 정보가 성공적으로 등록되었습니다.'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('확인'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MainPage()),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          }
        } else {}
      } else {
        print('Failed to send data');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('아기 정보 등록')),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: '아기 이름'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '아기 이름을 입력해주세요';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: InputDecoration(labelText: '성별'),
                  items: <String>['남자', '여자']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '성별을 선택해주세요';
                    }
                    return null;
                  },
                ),
                ListTile(
                  title: Text(
                    _birthdate == null
                        ? '생년월일 선택'
                        : '선택된 생일: ${DateFormat('yyyy-MM-dd').format(_birthdate!)}',
                  ),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null && picked != _birthdate) {
                      setState(() {
                        _birthdate = picked;
                      });
                    }
                  },
                ),
                SizedBox(height: 20),
                _image != null
                    ? Image.file(File(_image!.path))
                    : Text('아직 사진이 선택되지 않았습니다.'),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('사진 업로드'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('제출하기'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
