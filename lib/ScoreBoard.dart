import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreboardScreen extends StatefulWidget {
  @override
  _ScoreboardScreenState createState() => _ScoreboardScreenState();
}

class _ScoreboardScreenState extends State<ScoreboardScreen> {
  final String _correctPin = "1234"; // Admin PIN
  bool _isAuthenticated = false; // Track authentication status
  List<Map<String, dynamic>> scores = [];

  @override
  void initState() {
    super.initState();
    _loadScores(); // Load scores but do NOT call showDialog() here
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authenticateUser(); // Call authentication in didChangeDependencies()
  }

  // Show PIN dialog
  void _authenticateUser() {
    TextEditingController _pinController = TextEditingController();
    Future.delayed(Duration.zero, () { // Ensure it's called after widget is built
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent closing without entering PIN
        builder: (context) {
          return AlertDialog(
            title: Text("Enter PIN"),
            content: TextField(
              controller: _pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "PIN"),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pop(context); // Go back to the Welcome page
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  if (_pinController.text == _correctPin) {
                    Navigator.pop(context); // Close the PIN dialog
                    setState(() {
                      _isAuthenticated = true; // Unlock the scoreboard
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Incorrect PIN!")),
                    );
                  }
                },
                child: Text("Submit"),
              ),
            ],
          );
        },
      );
    });
  }

  // Load scores from SharedPreferences
  void _loadScores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedScores = prefs.getStringList('scores');
    if (storedScores != null) {
      setState(() {
        scores = storedScores.map((e) {
          List<String> parts = e.split('-');
          return {"name": parts[0], "score": int.parse(parts[1])};
        }).toList();
        scores.sort((a, b) => b['score'].compareTo(a['score'])); // Sort by score (highest first)
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scoreboard")),
      body: _isAuthenticated
          ? scores.isNotEmpty
              ? ListView.builder(
                  itemCount: scores.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(scores[index]['name']),
                      trailing: Text("Score: ${scores[index]['score']}"),
                    );
                  },
                )
              : Center(child: Text("No scores available."))
          : Center(child: CircularProgressIndicator()), // Show loading if still locked
    );
  }
}
