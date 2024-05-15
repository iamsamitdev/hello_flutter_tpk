import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hello_flutter/utils/constant.dart';

class AuthAPI {

  // สร้าง header เพื่อกำหนด format ของข้อมูลที่จะส่งไปยัง API
  _setHeaders() => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // สร้างฟังก์ชัน Login
  loginAPI(data) async {
    return await http.post(
      Uri.parse('${baseURLAPI}login.php'),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

}