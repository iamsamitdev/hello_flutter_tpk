// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hello_flutter/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  // สร้างตัวแปรไว้เก็บข้อมูล user
  String? _userFullname, _userEmail, _userRole, _userAvatar;

  // สร้างฟังก์ชันสำหรับอ่านข้อมูล user จาก SharedPreferences
  void _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userFullname = prefs.getString('loginFullname');
      _userEmail = prefs.getString('loginEmail');
      _userRole = prefs.getString('loginRole');
      _userAvatar = prefs.getString('loginAvatar');
    });
  }
  
  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  // Method Logout -----------------------------------------------------------
  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('isLogin');
    Navigator.pushReplacementNamed(context, '/login');

    // Clear all route and push to login screen
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          _buildHeader(),
          _buildListMenu(),
        ],
      ),
    );
  }

   // สร้าง widget สำหรับแสดงข้อมูล profile ที่อ่านมาจาก shared preference
  Widget _buildHeader() {
    return Container(
      height: 250,
      decoration: const BoxDecoration(
        color: Colors.blue,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: Image.network('$baseURLAPI$_userAvatar').image,
          ),
          const SizedBox(height: 10),
          Text(
            '$_userFullname',
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            '$_userEmail',
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // สร้าง widget สำหรับแสดงรายการเมนูต่างๆ
  Widget _buildListMenu() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Profile'),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
          ),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.password),
          title: const Text('Change Password'),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
          ),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('Change Language'),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
          ),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Setting'),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
          ),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Logout'),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
          ),
          onTap: logout,
        ),
      ],
    );
  }

}