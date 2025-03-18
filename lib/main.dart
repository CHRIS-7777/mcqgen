import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mcqgen/QuizScreen.dart';
import 'package:mcqgen/ScoreBoard.dart';
import 'package:mcqgen/WelcomeScreen.dart';
import 'package:mcqgen/thankyouscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyA3oyi74Dq3HGQmJFb9iClysSxgxu3aIkM',
      appId: '1:681718403729:android:a272d94841f8ed99dba530',
      messagingSenderId: '681718403729',
      projectId: 'mcqgen-3fd8c',
    ),
  );
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cricket-Quiz',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/welcome', // Set initial route
      routes: {
      '/welcome': (context) => WelcomeScreen(),
      '/quiz': (context) => QuizScreen(userName: 'hi'),
      '/thank': (context) => ThankYouScreen(userName: ''),
      '/score': (context) =>ScoreboardScreen(),
      }
    );
  }
}
