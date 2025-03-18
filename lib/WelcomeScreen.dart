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
        SnackBar(content: Text("🤯 Already attend panitinga Bro...")),
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
          title: Text("Pin Theriyuma:🤨", style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: _pinController,
            obscureText: true,
            keyboardType: TextInputType.number,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "Pin:",
              labelStyle: TextStyle(color: Colors.white70),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel", style: TextStyle(color: const Color.fromARGB(255, 255, 119, 119))),
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
                    SnackBar(content: Text("Pin Thappu Bro🤯..")),
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
      body: Stack(
        children: [
        Opacity(
            opacity: 1,
            child: Image.asset(
              "assets/ip.jpg",
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Column(
            children: [
              AppBar(
  backgroundColor: Colors.transparent, // Make AppBar background transparent
  elevation: 0, // Remove shadow
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
  ),
  title: Text("✨IPL QUIZ✨", style: TextStyle(fontSize: 35, color: Colors.white,fontWeight: FontWeight.bold)),
  centerTitle: true,
  flexibleSpace: Container(
    
  ),
),

              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "🏏Enter Your Name",
                          style: TextStyle(fontSize: 20, color: const Color.fromARGB(255, 255, 255, 255)),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _nameController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromARGB(255, 159, 2, 2).withOpacity(0.4),
                            labelText: "Name:",
                            labelStyle: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white, width: 1),
                            
                            ),
                          ),
                        ),
                        SizedBox(height: 130),
                        SizedBox(
  width: double.infinity,
  height: 50,
  child: ElevatedButton(
    onPressed: _startQuiz,
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 159, 2, 2).withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.white, width: 1), // White border
      ),
      
    ),
    child: Text(
      "Start Quiz",
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
    ),
  ),
),
SizedBox(height:10),
  SizedBox(
  width: double.infinity,
  height: 50,
  child: ElevatedButton(
    onPressed: _showPinDialog,
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 159, 2, 2).withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.white, width: 1), // White border
      ),
  
    ),
    child: Text(
      "View Score",
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
    ),
  ),
),

                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
