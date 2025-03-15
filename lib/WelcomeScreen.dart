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

  Future<void> _checkQuizAttempt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      hasAttemptedQuiz = prefs.getBool('hasAttemptedQuiz') ?? false;
    });
  }

  Future<void> _saveQuizAttempt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasAttemptedQuiz', true);
  }

  void _startQuiz() {
    if (_nameController.text.trim().isEmpty) {
      _showAlert("Name Required", "Please enter your name before starting the quiz.");
    } else if (hasAttemptedQuiz) {
      _showAlert("Quiz Already Attempted", "You have already attended the quiz! You cannot attempt it again.");
    } else {
      _saveQuizAttempt();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => QuizScreen(userName: _nameController.text.trim())),
      );
    }
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(title, style: TextStyle(color: Colors.white)),
        content: Text(message, style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Cricket Quiz App", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Enter Your Name", style: TextStyle(fontSize: 20, color: Colors.white)),
            SizedBox(height: 10),
            TextField(
              controller: _nameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Name",
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[900],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startQuiz,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text("Start Quiz", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ScoreboardScreen())),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text("View Scoreboard", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
