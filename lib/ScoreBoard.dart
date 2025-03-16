import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScoreboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Scoreboard", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('scores').orderBy('score', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var scores = snapshot.data!.docs;

          return ListView.builder(
            itemCount: scores.length,
            itemBuilder: (context, index) {
              var scoreData = scores[index].data() as Map<String, dynamic>;
              return Card(
                color: Colors.grey[800],
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(scoreData['name'], style: TextStyle(color: Colors.white)),
                  trailing: Text("Score: ${scoreData['score']}", style: TextStyle(color: Colors.white)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
