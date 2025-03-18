import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScoreboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/scorebg.jpg", // Set your background image path here
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Column(
            children: [
              AppBar(
                title: Text(
                  "Score Board",
                  style: TextStyle(color: const Color.fromARGB(225, 255, 0, 0), fontWeight: FontWeight.bold),
                ),
                backgroundColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
                elevation: 0,
                centerTitle: true,
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('scores').orderBy('score', descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    var scores = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: scores.length,
                      padding: EdgeInsets.all(10),
                      itemBuilder: (context, index) {
                        var scoreData = scores[index].data() as Map<String, dynamic>;
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(78, 255, 255, 255).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(132, 0, 0, 0).withOpacity(0.9),
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "📌 ${index + 1}. ${scoreData['name']}",
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Score: ${scoreData['score']}✨",
                                style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
