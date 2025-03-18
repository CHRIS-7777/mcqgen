import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mcqgen/scoreboard.dart';
import 'package:mcqgen/thankyouscreen.dart';

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

  Future<void> _fetchQuestions() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('questions').get();
    setState(() {
      quizQuestions = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      isLoading = false;
    });
  }
  void checkAnswer() async {
  if (selectedAnswer == quizQuestions[currentQuestionIndex]["answer"]) {
    score += 1;
  }

  if (currentQuestionIndex < quizQuestions.length - 1) {
    setState(() {
      currentQuestionIndex++;
      selectedAnswer = null;
    });
  } else {
    await saveScore();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ThankYouScreen(userName: widget.userName)),
    );
  }
}


  Future<void> saveScore() async {
    await FirebaseFirestore.instance.collection('scores').doc(widget.userName).set({
      'name': widget.userName,
      'score': score,
    });
    await FirebaseFirestore.instance.collection('users').doc(widget.userName).set({
      'attempted': true,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/download.jpg", // Set your background image here
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color.fromARGB(0, 0, 0, 0), const Color.fromARGB(102, 0, 0, 0)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "${currentQuestionIndex + 1}. ${quizQuestions[currentQuestionIndex]["question"]}",
                          style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 20),
                      Column(
                        children: quizQuestions[currentQuestionIndex]["options"].map<Widget>((option) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedAnswer = option;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: selectedAnswer == option ? const Color.fromARGB(255, 42, 134, 30) : Colors.white.withOpacity(0),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white, width: 1),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    selectedAnswer == option ? Icons.radio_button_checked : Icons.radio_button_off,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      option,
                                      style: TextStyle(fontSize: 18, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        width: 120,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: selectedAnswer != null ? checkAnswer : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 214, 18, 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side: BorderSide(color: Colors.white, width: 1),
                            ),
                          ),
                          child: Text(
                            "Next >>",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
