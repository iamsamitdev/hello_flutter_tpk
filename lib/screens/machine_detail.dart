// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:hello_flutter/utils/constant.dart';

class MachineDetail extends StatefulWidget {
  const MachineDetail({super.key});

  @override
  State<MachineDetail> createState() => _MachineDetailState();
}

class _MachineDetailState extends State<MachineDetail> {

  // กำหนดตัวแปรปรับ machine status และ maintenance status
  bool? machineStatus = false;
  bool? maintenanceStatus = false;

  @override
  Widget build(BuildContext context) {

    // รับค่าที่ส่งมาจากหน้า dashboard
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

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
                    Text(arguments['status']),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Maintenence Status:'),
                    Text(arguments['maintenance_status']),
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
                    Text('Machine Status'),
                    Switch(
                      value: arguments['status'] == 'หยุดทำงาน' ?  machineStatus!: !machineStatus!, 
                      onChanged: (value) {
                        setState(() {
                          machineStatus = machineStatus! ? false : true;
                        });
                      }
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Manchine Maintenence'),
                    Switch(
                      value: arguments['maintenance_status'] == 'รอซ่อมบำรุง' ?  maintenanceStatus!: !maintenanceStatus!, 
                      onChanged: (value) {
                        setState(() {
                          maintenanceStatus = maintenanceStatus! ? false : true;
                        });
                      }
                    )
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: (){},
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