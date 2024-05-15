// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:hello_flutter/screens/home.dart';
import 'package:hello_flutter/screens/machine.dart';
import 'package:hello_flutter/screens/profile.dart';
import 'package:hello_flutter/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

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

  // ส่วนของการกำหนด BottomNavigationBar
  // กำหนดตัวแปร currentIndex ให้เป็น 0
  int _currentIndex = 0;

  // สร้างตัวแปรเก็บ title ของแต่ละหน้า
  String _title = 'Machine Management';

  // สร้าง List ของหน้าที่ต้องการเปลี่ยน
  final List<Widget> _children = [
    Home(),
    Machine(),
    Profile(),
  ];

  // สร้างเมธอดสำหรับเปลี่ยนหน้า
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      switch (index) {
        case 0: _title = 'Dashboard'; break;
        case 1: _title = 'Machine'; break;
        case 2: _title = 'Profile'; break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.pushNamed(context, '/about');
            }, 
            icon: const Icon(Icons.qr_code),
          ),
          IconButton(onPressed: (){}, icon: const Icon(Icons.notifications),),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text('$_userFullname ($_userRole)'), 
                  accountEmail: Text(_userEmail ?? ''),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: Image.network('$baseURLAPI$_userAvatar').image,
                  ),
                ),
                ListTile(
                  title: Text('Infomation'),
                  leading: Icon(Icons.info),
                  onTap: () {
                    Navigator.pushNamed(context, '/about');
                  },
                ),
                ListTile(
                  title: Text('Contact Us'),
                  leading: Icon(Icons.info),
                  onTap: () {},
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Divider(),
                  ListTile(
                    title: Text('Logout'),
                    leading: Icon(Icons.exit_to_app),
                    onTap: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool('loginStatus', false);
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                  ListTile(
                    title: Text('Version 1.0.0'),
                    leading: Icon(Icons.code),
                  ),
                ],
              )
            ),
          ],
        ),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          onTabTapped(index);
        },
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.space_dashboard_outlined),
            label: 'Dashboard'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build_circle_outlined),
            label: 'Machine'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile'
          )
        ],
      ),
    );
  }
}