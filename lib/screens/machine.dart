// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hello_flutter/models/plc_machine_model.dart';
import 'package:hello_flutter/services/machine_api.dart';
import 'package:hello_flutter/utils/constant.dart';

// สร้าง key สำหรับ refreshIndicator
var refreshKey = GlobalKey<RefreshIndicatorState>();

class Machine extends StatefulWidget {
  const Machine({super.key});

  @override
  State<Machine> createState() => _MachineState();
}

class _MachineState extends State<Machine> {

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
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    machine.status!,
                    style: TextStyle(
                      color: machine.status == 'ทำงานปกติ' ? Colors.green : Colors.red
                    ),
                  ),
                  Text(
                    machine.maintenanceStatus!,
                    style: TextStyle(
                      color: machine.maintenanceStatus == 'ไม่ต้องซ่อมบำรุง' ? Colors.green : Colors.yellow[700]
                    ),
                  ),
                ],
              ),
              shape: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
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