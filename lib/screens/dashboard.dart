// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:hello_flutter/models/plc_machine_model.dart';
import 'package:hello_flutter/services/machine_api.dart';
import 'package:hello_flutter/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

// สร้าง key สำหรับ refreshIndicator
var refreshKey = GlobalKey<RefreshIndicatorState>();

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

  // ทดสอบเรียก API จาก MachineAPI
  // สร้างตัวแปร List เพื่อเก็บข้อมูลที่ได้จาก API
  List<PlcMachineModel> machineData = [];

  // สร้างเมธอดสำหรับเรียกข้อมูลจาก API
  void _getMachineData() async {
    var data = await MachineAPI().getAllMachine();
    setState(() {
      machineData = data;
    });
    // var jsonData = jsonEncode(data);
    // print(jsonData);
  }

  @override
  void initState() {
    super.initState();
    _getMachineData();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
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
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          _getMachineData(); // อ่านข้อมูลใหม่จาก API
        },
        child: ListView.builder(
          itemCount: machineData.length,
          itemBuilder: (context, index) {
            final machine = machineData[index];
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  Uri.parse(baseURLAPI+machine.imageUrl!).toString(),
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(machine.name!),
              subtitle: Text(machine.location!),
              trailing: Text(
                machine.status!,
                style: TextStyle(
                  color: machine.status == 'ทำงานปกติ' ? Colors.green : Colors.red
                ),
              ),
              onTap: () {
                Navigator.pushNamed(
                  context, 
                  '/machine_detail', 
                  arguments: machine.toJson()
                );
              },
            );
          }
        ),
      ),
    );
  }
}