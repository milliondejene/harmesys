// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../HarmeClinicManagementSystem.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HarmeClinicManagementSystem(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Image(
                image: AssetImage("assets/icons/hospital.png"),
                width: 100,
                height: 100),
            SizedBox(height: 25),
            Text(
              "Harme Clinic \nManagement System",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(13, 37, 87, 0.8),
              ),
            ),
            SizedBox(height: 25),
            SpinKitDoubleBounce(
              color: Colors.blue,
              size: 30.0,
            ),
          ],
        ),
      ),
    );
  }
}
