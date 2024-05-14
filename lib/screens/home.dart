import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            // คำสั่งเปลี่ยนไปหน้า about และเก็บหน้า home อยู่ใน stack
            Navigator.pushNamed(context, '/about');

            // คำสั่งเปลี่ยนไปหน้า about และลบหน้า home ออก
            // Navigator.pushReplacementNamed(context, '/about');
          }, 
          child: const Text('Go About'),
        ),
      ),
    );
  }
}