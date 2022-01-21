import 'package:flutter/material.dart';

import './question.dart';
import './answer.dart';
import './quiz.dart';
import './result.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  int _questionIndex = 0;
  int _totalScore = 0;
  var questions = [
    {
      'questionText': "what is your favorite color",
      'answers': [
        {'text': 'red', 'score': 10},
        {'text': 'green', 'score': 10},
      ]
    },
    {
      'questionText': "what is your favorite animal",
      'answers': [
        {'text': 'Lion', 'score': 10},
        {'text': 'Tiger', 'score': 7},
        {'text': 'Dog', 'score': 20},
        {'text': 'Bird', 'score': 15}
      ]
    },
    {
      'questionText': "what is your favorite programming language",
      'answers': [
        {'text': 'Javascript', 'score': 50},
        {'text': 'PHP', 'score': 30},
        {'text': 'Go', 'score': 20},
        {'text': 'Java', 'score': 10}
      ]
    }
  ];

  void _answerQuestion(int score) {
    setState(() {
      if (_questionIndex < questions.length) {
        _questionIndex = _questionIndex + 1;
      }
      _totalScore += score;
    });
    print("question anwser");
  }

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
    });
  }

  Widget build(BuildContext content) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text("My brand new application"),
          ),
          body: _questionIndex < questions.length
              ? Quiz(
                  answerQuestion: _answerQuestion,
                  questionIndex: _questionIndex,
                  questions: questions)
              : Result(_totalScore, _resetQuiz)),
    );
  }
}
