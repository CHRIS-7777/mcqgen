📝 Quiz App – Test Your Knowledge! 🎯📱
📌 Overview
The Quiz App is a Flutter-based application designed to test users' knowledge through multiple-choice questions (MCQs). It ensures fairness by allowing each participant to take the quiz only once. A secure scoreboard stores and ranks scores in descending order, accessible only with an admin PIN.

✨ Features
✅ Welcome Screen – Users enter their name before starting the quiz.
✅ MCQ-Based Quiz – Engaging multiple-choice questions.
✅ Single Attempt Policy – Prevents users from retaking the quiz, even if they change their name.
✅ Scoreboard with PIN Protection – Accessible only with a secure PIN for admin control.
✅ Descending Score Ranking – Scores are stored and displayed from highest to lowest.
✅ Persistent Data Storage – Uses SharedPreferences to save user attempts and scores.
✅ Error Handling & Alerts – Provides notifications for missing names, incorrect PINs, and quiz attempt restrictions.

🚀 How It Works

Users enter their name on the Welcome Screen.
Press Start Quiz to begin answering multiple-choice questions.
After submitting, a thank you message is displayed.
Once a user attempts the quiz, they cannot retake it, even with a different name.
The Scoreboard is protected and requires a PIN for access.
Scores are ranked in descending order based on performance.

📌 Tech Stack

Flutter (Dart) – For building a responsive UI.
SharedPreferences – For storing user data and quiz status locally.
Material UI Components – Ensures a clean and user-friendly interface.

🔐 Admin Access

The Scoreboard is restricted and accessible only with a PIN (default: 1234).
An alert is displayed for incorrect PIN entries.
This project provides an interactive way for users to test their knowledge while ensuring fair play and secure score tracking! 🚀📚
