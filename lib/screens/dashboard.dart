// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hello_flutter/models/plc_machine_model.dart';
import 'package:hello_flutter/services/machine_api.dart';
import 'package:hello_flutter/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

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
          IconButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool('loginStatus', false);
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView.builder(
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
            trailing: Text(machine.status!),
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
    );
  }
}