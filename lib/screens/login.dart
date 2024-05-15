// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hello_flutter/services/auth_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  // สร้างตัวแปรสำหรับไว้กำหนด key ให้กับฟอร์ม
  final _formLoginKey = GlobalKey<FormState>();

  // สร้างตัวแปรสำหรับเก็บค่า email และ password
  String? _email, _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.teal],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/itglogo.png',
                        height: 150,
                      ),
                      Form(
                        key: _formLoginKey,
                        child: Column(
                          children: [
                            TextFormField(
                              initialValue: 'admin@email.com',
                              decoration: InputDecoration(
                                hintText: 'Email',
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                // เช็คว่าถ้าช่อง email เป็นค่าว่าง
                                if(value!.isEmpty) {
                                  return 'กรุณากรอกอีเมล์';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _email = value;
                              },
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              initialValue: '123456',
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                prefixIcon: Icon(Icons.lock),
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                // เช็คว่าถ้าช่อง password เป็นค่าว่าง
                                if(value!.isEmpty) {
                                  return 'กรุณากรอกรหัสผ่าน';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _password = value;
                              },
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(double.infinity, 50),
                              ),
                              onPressed: () async {
                                // เมื่อกดปุ่ม login ให้ทำการ validate ค่าในฟอร์ม
                                if(_formLoginKey.currentState!.validate()){
                                  // ถ้าค่าที่กรอกในฟอร์มถูกต้อง ให้ทำการ save ค่าในฟอร์ม
                                  _formLoginKey.currentState!.save();

                                  // แสดงค่าที่ได้จากการกรอกในฟอร์ม
                                  // print('Email: $_email');
                                  // print('Password: $_password');

                                  // เรียกใช้งาน API สำหรับ login
                                  var response = await AuthAPI().loginAPI(
                                    {
                                    'email': _email,
                                    'password': _password,
                                    }
                                  );

                                  var body = jsonDecode(response.body);

                                  // ตรวจเงื่อนไขการ login
                                  if(body['status'] == 'success'){
                                    // บันทึกข้อมูลการ login ลงในเครื่อง
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.setBool('loginStatus', true);
                                    prefs.setString('loginFullname', body['user']['fullname']);
                                    prefs.setString('loginEmail', body['user']['email']);
                                    prefs.setString('loginRole', body['user']['role']);
                                    prefs.setString('loginAvatar', body['user']['avatar']);
                                    
                                    // ส่งไปหน้า dashboard
                                    Navigator.pushReplacementNamed(context, '/dashboard');
                                  } else {
                                    // แสดงข้อความเมื่อ login ไม่สำเร็จ
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        content: Text('Email หรือ Password ไม่ถูกต้อง'),
                                        backgroundColor: Colors.red,
                                      )
                                    );
                                  }
                                }
                              }, 
                              child: Text('LOG IN')
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}