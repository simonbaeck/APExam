import 'package:flutter/material.dart';
import 'package:flutter_project/student/questions/question.class.dart';
import '../../services/toaster.dart';
import '../../styles/styles.dart';
import 'answer.class.dart';

class OpenQuestion extends StatefulWidget {
  final Question question;
  final String studentId;
  final Answer? antwoord;

  const OpenQuestion({Key? key, required this.question, required this.studentId, this.antwoord}) : super(key: key);

  @override
  State<OpenQuestion> createState() => _OpenQuestionState();
}

class _OpenQuestionState extends State<OpenQuestion> {

  final textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.antwoord != null) {
      textFieldController.text = widget.antwoord!.antwoord;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

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
              Answer toAdd = Answer();
              toAdd.questionId = widget.question.id;
              toAdd.antwoord = textFieldController.text;
              toAdd.studentId = widget.studentId;
              Toaster().showToastMsg("Examen ingediend");
              Navigator.of(context).pop(toAdd);
            },
            child: const Text('Beantwoorden'),
          )
        ],
      ),
    );
  }
}
