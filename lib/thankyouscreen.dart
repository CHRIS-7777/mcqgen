import 'package:flutter/material.dart';
import 'package:mcqgen/scoreboard.dart'; // Import ScoreboardScreen if needed

class ThankYouScreen extends StatelessWidget {
  final String userName;

  ThankYouScreen({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/dhoni.jpg", // Replace with your actual image path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7), // Transparent background
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Thank You Machi ✨$userName",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Quiz super ah answer panna✨",
                    style: TextStyle(fontSize: 18, color: const Color.fromARGB(230, 255, 255, 255)),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  Text("Result Soluvanga,konjom wait pannu👊..",style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 255, 255, 255)),
                    textAlign: TextAlign.center,)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
