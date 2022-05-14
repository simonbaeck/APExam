import 'package:flutter/material.dart';
import 'package:flutter_project/student/questions/question.class.dart';
import 'package:flutter/material.dart';

import '../../services/toaster.dart';
import '../../styles/styles.dart';

class CorrectionQuestion extends StatefulWidget {
  final Question question;

  const CorrectionQuestion({Key? key, required this.question})
      : super(key: key);

  @override
  State<CorrectionQuestion> createState() => _CorrectionQuestionState();
}

class _CorrectionQuestionState extends State<CorrectionQuestion> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Questions'),
        ),
        body: correctionQuestion(),
      );

  Widget correctionQuestion() {
    final textFieldController =
        TextEditingController(text: widget.question.antwoord);
    return Container(
      child: Column(
        children: [
          Text(
            'Corrigeer volgende code:',
            style: Styles.headerStyleH1,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            widget.question.vraag,
            style: Styles.textColorBlack,
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: textFieldController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Correctie',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              widget.question.addAnswer(textFieldController.text);
              Toaster().showToastMsg("Vraag beantwoord");
              Navigator.of(context).pop();
            },
            child: const Text('Beantwoorden'),
          )
        ],
      ),
    );
  }
}
