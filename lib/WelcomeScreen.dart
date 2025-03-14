import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'QuizScreen.dart';
import 'Scoreboard.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  TextEditingController _nameController = TextEditingController();
  bool hasAttemptedQuiz = false;

  @override
  void initState() {
    super.initState();
    _checkQuizAttempt();
  }

  // Check if the user has already attempted the quiz
  Future<void> _checkQuizAttempt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      hasAttemptedQuiz = prefs.getBool('hasAttemptedQuiz') ?? false;
    });
  }

  // Save quiz attempt to prevent retaking
  Future<void> _saveQuizAttempt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasAttemptedQuiz', true);
  }

  // Function to start the quiz
  void _startQuiz() {
    if (_nameController.text.trim().isEmpty) {
      // Show an alert box if the name field is empty
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Name Required"),
            content: Text("Please enter your name before starting the quiz."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } else if (hasAttemptedQuiz) {
      // Show an alert box if the user has already attended the quiz
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Quiz Already Attempted"),
            content: Text("You have already attended the quiz!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      // Start quiz and mark as attempted
      _saveQuizAttempt();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizScreen(userName: _nameController.text.trim()),
        ),
      );
    }
  }

  // Navigate to Scoreboard directly
  void _goToScoreboard() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScoreboardScreen()), // No Dialog, Direct Navigation
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cricket Quiz")),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Enter Your Name", style: TextStyle(fontSize: 20)),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startQuiz,
              child: Text("Start Quiz"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _goToScoreboard, // Navigate without Dialog
              child: Text("View Scoreboard"),
            ),
          ],
        ),
      ),
    );
  }
}
