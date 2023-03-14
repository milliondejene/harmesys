// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Clinic System',
        theme: ThemeData(
          primaryColor: const Color.fromRGBO(13, 37, 87, 1),
          cardColor: const Color.fromRGBO(100, 142, 209, 1),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const SplashScreen());
  }
}
