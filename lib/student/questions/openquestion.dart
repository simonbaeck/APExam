import 'package:flutter/material.dart';
import 'package:flutter_project/student/questions/question.class.dart';
import 'package:flutter/material.dart';

import '../../services/toaster.dart';
import '../../styles/styles.dart';

class OpenQuestion extends StatefulWidget {
  final Question question;
  const OpenQuestion({Key? key, required this.question}) : super(key: key);

  @override
  State<OpenQuestion> createState() => _OpenQuestionState();
}

class _OpenQuestionState extends State<OpenQuestion> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Questions'),
        ),
        body: openquestion(),
      );

  Widget openquestion() {
    final textFieldController =
        TextEditingController(text: widget.question.antwoord);
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
          TextFormField(
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
              widget.question.addAnswer(textFieldController.text);
              Toaster().showToastMsg("Examen ingediend");

              Navigator.of(context).pop();
            },
            child: const Text('Beantwoorden'),
          )
        ],
      ),
    );
  }
}
