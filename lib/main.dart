import 'package:flutter/material.dart';
import 'package:mcqgen/WelcomeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cricket Quiz',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/welcome', // Set initial route
      routes: {
      '/welcome': (context) => WelcomeScreen(),
      }
    );
  }
}
