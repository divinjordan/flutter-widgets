import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final int totalScore;
  final Function resetQuiz;

  Result(this.totalScore, this.resetQuiz);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(child: Text('You done it ! Then your score')),
        Text(totalScore.toString()),
        FlatButton(
          child: Text('Reset quiz'),
          onPressed: resetQuiz,
          textColor: Colors.blue,
        )
      ],
    );
  }
}
