import 'package:http/http.dart' as http;
import 'package:hello_flutter/utils/constant.dart';
import 'package:hello_flutter/models/plc_machine_model.dart';

class MachineAPI {

  // สร้าง header เพื่อกำหนด format ของข้อมูลที่จะส่งไปยัง API
  _setHeaders() => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // สร้างเมธอดสำหรับเรียกข้อมูลจาก API
  Future<List<PlcMachineModel>> getAllMachine() async {
    final response = await http.get(
      Uri.parse('${baseURLAPI}machine.php'),
      headers: _setHeaders(),
    );
    // เช็คว่ามีข้อมูลที่ส่งกลับมาหรือไม่
    if(response.body.isNotEmpty){
      return plcMachineModelFromJson(response.body);
    } else {
      return [];
    }
  }

}