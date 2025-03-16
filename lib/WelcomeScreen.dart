import 'package:flutter/material.dart';
import 'package:mcqgen/QuizScreen.dart';
import 'package:mcqgen/scoreboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _pinController = TextEditingController();
  final String correctPin = "1234"; // Set your PIN

  @override
  void initState() {
    super.initState();
    _checkAttemptStatus();
  }

  bool hasAttempted = false; // Flag for checking attempt

  Future<void> _checkAttemptStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      hasAttempted = prefs.getBool('hasAttemptedQuiz') ?? false;
    });
  }

  Future<void> _startQuiz() async {
    if (hasAttempted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You have already attempted the quiz on this device!")),
      );
      return;
    }

    String userName = _nameController.text.trim();
    if (userName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter your name")),
      );
      return;
    }

    // Store attempt status on this device
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasAttemptedQuiz', true);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(userName: userName),
      ),
    );
  }

  void _showPinDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.black87,
          title: Text("Enter pin", style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: _pinController,
            obscureText: true,
            keyboardType: TextInputType.number,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "pin",
              labelStyle: TextStyle(color: Colors.white70),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel", style: TextStyle(color: Colors.redAccent)),
            ),
            TextButton(
              onPressed: () {
                if (_pinController.text == correctPin) {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ScoreboardScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Incorrect PIN!")),
                  );
                }
              },
              child: Text("Submit", style: TextStyle(color: Colors.greenAccent)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 31, 31, 31),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          title: Text("IPL - QUIZ", style: TextStyle(fontSize: 24,color:Colors.white)),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.indigo,Colors.teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Enter Your Name",
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _nameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 77, 77, 77),
                  labelText: "Name",
                  labelStyle: TextStyle(color: const Color.fromARGB(179, 255, 255, 255)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: const Color.fromARGB(255, 255, 255, 255), width: 2),
                  ),
                ),
              ),
              SizedBox(height: 100),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _startQuiz,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("Start Quiz", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _showPinDialog,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("View Score", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
