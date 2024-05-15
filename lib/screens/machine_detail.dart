// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hello_flutter/screens/dashboard.dart';
import 'package:hello_flutter/services/machine_api.dart';
import 'package:hello_flutter/utils/constant.dart';

class MachineDetail extends StatefulWidget {
  const MachineDetail({super.key});

  @override
  State<MachineDetail> createState() => _MachineDetailState();
}

class _MachineDetailState extends State<MachineDetail> {

  // กำหนดตัวแปรปรับ machine status และ maintenance status
  bool? machineStatus = true;
  bool? maintenanceStatus = true;

  @override
  Widget build(BuildContext context) {

    // รับค่าที่ส่งมาจากหน้า dashboard
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    // machineStatus = arguments['status'] == 'ทำงานปกติ' ? true : false;
    // maintenanceStatus = arguments['maintenance_status'] == 'ไม่ต้องซ่อมบำรุง' ? true : false;

    return Scaffold(
      appBar: AppBar(
        title: Text(arguments['name']),
      ),
      body: ListView(
        children: [
          Image.network(
            baseURLAPI + arguments['image_url'],
            height: 280,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Machine ID:'),
                    Text(arguments['id'].toString()),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Machine Name:'),
                    Text(arguments['name']),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Machine Location:'),
                    Text(arguments['location']),
                  ],
                ),
                SizedBox(height: 10),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Machine status:'),
                    Text(
                      arguments['status'],
                      style: TextStyle(
                        color: arguments['status'] == 'หยุดทำงาน' ? Colors.red : Colors.green
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Maintenence Status:'),
                    Text(
                      arguments['maintenance_status'],
                      style: TextStyle(
                        color: arguments['maintenance_status'] == 'รอซ่อมบำรุง' ? Colors.yellow : Colors.green
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Model:'),
                    Text(arguments['other_details']['รุ่น']),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Manufacturer:'),
                    Text(arguments['other_details']['ผู้ผลิต']),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Year: '),
                    Text(arguments['other_details']['ปีที่ผลิต'].toString()),
                  ],
                ),
                SizedBox(height: 20),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Stop Machine'),
                    Switch(
                      value: !machineStatus!, 
                      onChanged: (value) {
                        setState(() {
                          machineStatus = !machineStatus!;
                        });
                      }
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Start Maintenence'),
                    Switch(
                      value: !maintenanceStatus!, 
                      onChanged: (value) {
                        setState(() {
                          maintenanceStatus = !maintenanceStatus!;
                        });
                      }
                    )
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {

                    print(
                      {
                        'id': arguments['id'],
                        'status': machineStatus!,
                        'maintenance_status': maintenanceStatus!,
                      }
                    );
                    // ส่งข้อมูลไปยัง API เพื่อปรับ status ของ machine
                    var response = await MachineAPI().updateMachineStatus(
                      {
                        'id': arguments['id'],
                        'status': machineStatus!,
                        'maintenance_status': maintenanceStatus!,
                      }
                    );
                    var body = jsonDecode(response.body);
                    
                    if(body['message'] != null){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text(body['message']),
                          duration: Duration(seconds: 3),
                          backgroundColor: Colors.green,
                        )
                      );
                      Navigator.pop(context);
                      // Reload หน้า dashboard
                      refreshKey.currentState!.show();

                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text('RECORD'),
                ),
                SizedBox(height: 20),
              ],
            ),
          )
        ],
      )
    );
  }
}