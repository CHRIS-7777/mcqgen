import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mcqgen/scoreboard.dart';

class QuizScreen extends StatefulWidget {
  final String userName;
  QuizScreen({required this.userName});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, dynamic>> quizQuestions = [];
  int currentQuestionIndex = 0;
  String? selectedAnswer;
  int score = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  // Fetch quiz questions from Firestore
  Future<void> _fetchQuestions() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('questions').get();
    setState(() {
      quizQuestions = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      isLoading = false;
    });
  }

  // Check user's answer and move to next question
  void checkAnswer() async {
    if (selectedAnswer == quizQuestions[currentQuestionIndex]["answer"]) {
      score += 1; // Increase score for correct answer
    }

    if (currentQuestionIndex < quizQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
      });
    } else {
      await saveScore(); // Save score and mark as attempted
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ScoreboardScreen()),
      );
    }
  }

  // Save score and mark user as "attempted" in Firestore
  Future<void> saveScore() async {
    await FirebaseFirestore.instance.collection('scores').doc(widget.userName).set({
      'name': widget.userName,
      'score': score,
    });

    // Prevent multiple attempts
    await FirebaseFirestore.instance.collection('users').doc(widget.userName).set({
      'attempted': true,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Cricket Quiz", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quizQuestions[currentQuestionIndex]["question"],
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  ...quizQuestions[currentQuestionIndex]["options"].map<Widget>((option) {
                    return RadioListTile<String>(
                      title: Text(option, style: TextStyle(color: Colors.white)),
                      value: option,
                      groupValue: selectedAnswer,
                      onChanged: (value) {
                        setState(() {
                          selectedAnswer = value;
                        });
                      },
                    );
                  }).toList(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: selectedAnswer != null ? checkAnswer : null,
                    child: Text("Next"),
                  ),
                ],
              ),
            ),
    );
  }
}
