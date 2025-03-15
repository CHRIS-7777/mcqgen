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
    _loadScores();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authenticateUser();
  }

  void _authenticateUser() {
    TextEditingController _pinController = TextEditingController();
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[850], // Dark Grey Background
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // Rounded Corners
            ),
            title: Text("Enter PIN", style: TextStyle(color: Colors.white)),
            content: TextField(
              controller: _pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "PIN",
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text("Cancel", style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () {
                  if (_pinController.text == _correctPin) {
                    Navigator.pop(context);
                    setState(() {
                      _isAuthenticated = true;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Incorrect PIN!", style: TextStyle(color: Colors.white)),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                },
                child: Text("Submit", style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    });
  }

  void _loadScores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedScores = prefs.getStringList('scores');
    if (storedScores != null) {
      setState(() {
        scores = storedScores.map((e) {
          List<String> parts = e.split('-');
          return {"name": parts[0], "score": int.parse(parts[1])};
        }).toList();
        scores.sort((a, b) => b['score'].compareTo(a['score']));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Scoreboard", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900],
      ),
      body: _isAuthenticated
          ? scores.isNotEmpty
              ? ListView.builder(
                  itemCount: scores.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.grey[800],
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(scores[index]['name'], style: TextStyle(color: Colors.white)),
                        trailing: Text("Score: ${scores[index]['score']}", style: TextStyle(color: Colors.white)),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text("No scores available.", style: TextStyle(color: Colors.white)),
                )
          : Center(child: CircularProgressIndicator()),
    );
  }
}