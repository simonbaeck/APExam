import 'package:flutter/material.dart';
import 'package:flutter_project/student/questions/question.class.dart';
import 'package:flutter/material.dart';

import '../../styles/styles.dart';

class MultipleChoiceQuestion extends StatefulWidget {
  final Question question;

  const MultipleChoiceQuestion({Key? key, required this.question})
      : super(key: key);

  @override
  State<MultipleChoiceQuestion> createState() => _MultipleChoiceQuestionState();
}

class _MultipleChoiceQuestionState extends State<MultipleChoiceQuestion> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Questions'),
        ),
        body: multipleChoiceQuestion(),
      );

  late List<bool> _isSelected = [];
  late Set _saved = Set();

  @override
  Widget multipleChoiceQuestion() {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.question.antwoorden.length,
        itemBuilder: (context, index) {
          _isSelected.add(false);
          return CheckboxListTile(
            title: Text(widget.question.antwoorden[index]),
            checkColor: Colors.indigo,
            value: _isSelected[index],
            onChanged: (bool? newValue) {
              setState(() {
                if (_isSelected[index] == false) {
                  _saved.add(widget.question.antwoorden[index]);
                } else {
                  _saved.remove(widget.question.antwoorden[index]);
                }
                print(_saved);
                _isSelected[index] = newValue!;
              });
            },
          );
        },
      ),
    );
  }
}
