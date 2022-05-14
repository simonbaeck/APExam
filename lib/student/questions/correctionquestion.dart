import 'package:flutter/material.dart';
import 'package:flutter_project/student/questions/question.class.dart';
import '../../services/toaster.dart';
import '../../styles/styles.dart';
import 'answer.class.dart';

class CorrectionQuestion extends StatefulWidget {
  final Question question;
  final String studentId;
  final Answer? antwoord;

  const CorrectionQuestion({Key? key, required this.question, required this.studentId, this.antwoord}) : super(key: key);

  @override
  State<CorrectionQuestion> createState() => _CorrectionQuestionState();
}

class _CorrectionQuestionState extends State<CorrectionQuestion> {

  final textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.antwoord != null) {
      textFieldController.text = widget.antwoord!.antwoord;
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Questions'),
        ),
        body: correctionQuestion(),
      );

  Widget correctionQuestion() {
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
              Answer toAdd = Answer();
              toAdd.questionId = widget.question.id;
              toAdd.antwoord = textFieldController.text;
              toAdd.studentId = widget.studentId;
              Toaster().showToastMsg("Vraag beantwoord");
              Navigator.of(context).pop(toAdd);
            },
            child: const Text('Bevestig'),
          )
        ],
      ),
    );
  }
}
