// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(
      headerBackgroundColor: Colors.white,
      finishButtonText: 'Login',
      finishButtonStyle: FinishButtonStyle(
        backgroundColor: Colors.black,
      ),
      onFinish: () {
        Navigator.pushNamed(context, '/login');
      },
      skipTextButton: Text('ข้าม'),
      // trailing: Text('Login'),
      centerBackground: true,
      background: [
        Image.asset('assets/images/slider1.png', height: 400,),
        Image.asset('assets/images/slider2.png', height: 400,),
        Image.asset('assets/images/slider3.png', height: 400,),
      ],
      totalPage: 3,
      speed: 1.8,
      pageBodies: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 480,
              ),
              Text(
                'This is a description text for the first page of the onboarding slider and it can be as long as you want it to be. You can add any widget here and style it as you want.',
                style: TextStyle(
                  fontSize: 20,
                )
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 480,
              ),
              Text(
                'This is a description text for the second page of the onboarding slider and it can be as long as you want it to be. You can add any widget here and style it as you want.',
                style: TextStyle(
                  fontSize: 20,
                )
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 480,
              ),
              Text(
                'This is a description text for the third page of the onboarding slider and it can be as long as you want it to be. You can add any widget here and style it as you want.',
                style: TextStyle(
                  fontSize: 20,
                )
              ),
            ],
          ),
        ),
      ],
    );
  }
}
