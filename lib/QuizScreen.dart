import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizScreen extends StatefulWidget {
  final String userName;
  QuizScreen({required this.userName});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, dynamic>> quizQuestions = [
    {"question": "Who won the ICC Cricket World Cup 2011?", "options": ["India", "Australia", "Pakistan", "Sri Lanka"], "answer": "India"},
    {"question": "Which cricketer has scored the most international centuries?", "options": ["Sachin Tendulkar", "Virat Kohli", "Ricky Ponting", "Jacques Kallis"], "answer": "Sachin Tendulkar"},
    {"question": "How many balls are there in an over?", "options": ["4", "5", "6", "8"], "answer": "6"},
    {"question": "How many balls are there in an over?", "options": ["4", "5", "6", "8"], "answer": "6"}
  ];

  int currentQuestionIndex = 0;
  String? selectedAnswer;
  int score = 0;

  void checkAnswer() async {
    if (selectedAnswer == quizQuestions[currentQuestionIndex]["answer"]) {
      score += 10;
    }

    if (currentQuestionIndex < quizQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
      });
    } else {
      await saveScore();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: Text("Quiz Completed", style: TextStyle(color: Colors.white)),
            content: Text("Thank you for attending the quiz!\nThe selected students will be announced soon.", style: TextStyle(color: Colors.white)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text("OK", style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> saveScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedScores = prefs.getStringList('scores') ?? [];
    storedScores.add("${widget.userName}-${score}");
    await prefs.setStringList('scores', storedScores);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Cricket Quiz", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(quizQuestions[currentQuestionIndex]["question"], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 20),
            ...quizQuestions[currentQuestionIndex]["options"].map<Widget>((option) {
              return RadioListTile<String>(
                title: Text(option, style: TextStyle(color: Colors.white)),
                value: option,
                groupValue: selectedAnswer,
                activeColor: Colors.white,
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}
