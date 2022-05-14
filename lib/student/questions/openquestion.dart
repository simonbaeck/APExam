import 'package:flutter/material.dart';
import 'package:flutter_project/student/questions/question.class.dart';
import 'package:flutter/material.dart';

import '../../styles/styles.dart';

class OpenQuestion extends StatefulWidget {
  final Question question;
  const OpenQuestion({Key? key, required this.question}) : super(key: key);

  @override
  State<OpenQuestion> createState() => _OpenQuestionState();
}

class _OpenQuestionState extends State<OpenQuestion> {
  final textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Questions'),
        ),
        body: openquestion(),
      );

  Widget openquestion() {
    return Container(
      child: Column(
        children: [
          Text(
            widget.question.vraag,
            style: Styles.headerStyleH1,
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: textFieldController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Antwoord',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              widget.question.beantwoord = true;
            },
            child: const Text('Beantwoorden'),
          )
        ],
      ),
    );
  }
}
