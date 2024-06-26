import 'package:flutter/material.dart';
import 'package:hello_flutter/screens/about.dart';
import 'package:hello_flutter/screens/chart.dart';
import 'package:hello_flutter/screens/dashboard.dart';
import 'package:hello_flutter/screens/home.dart';
import 'package:hello_flutter/screens/login.dart';
import 'package:hello_flutter/screens/machine_detail.dart';
import 'package:hello_flutter/screens/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

// สร้างตัวแปรเก็บ initialRoute
dynamic initialRoute;

void main() async {
  // ต้องเรียกใช้ WidgetsFlutterBinding.ensureInitialized(); ก่อนเรียกใช้ SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();

  // อ่านข้อมูลจาก SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // ตรวจสอบว่ามีข้อมูลการ login หรือไม่
  if(prefs.getBool('loginStatus') == true){
    // ถ้ามีข้อมูลการ login ให้ส่งไปหน้า dashboard
    initialRoute = '/dashboard';
  } else {
    // ถ้าไม่มีข้อมูลการ login ให้ส่งไปหน้า welcome
    initialRoute = '/welcome';
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
       fontFamily: 'NotoSansThai',
       appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(
          fontFamily: 'NotoSansThai',
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
      ),
       primarySwatch: Colors.blue,
       useMaterial3: false,
      ),
      initialRoute: initialRoute,
      routes: {
        '/home': (context) => const Home(),
        '/about': (context) => const About(),
        '/welcome':(context) => const Welcome(),
        '/login':(context) => const Login(),
        '/dashboard':(context) => const Dashboard(),
        '/machine_detail':(context) => const MachineDetail(),
        '/chart':(context) => const ChartReport(),
      },
    );
  }
}

