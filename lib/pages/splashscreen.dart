import 'package:flutter/material.dart';
import 'package:chatapp/pages/signup.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Signup()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF2C6535), 
        child: Center(
          child: Image.asset(
            'images/logo.png',
            width: 150.0, 
            height: 150.0,
          ),
        ),
      ),
    );
  }
}
