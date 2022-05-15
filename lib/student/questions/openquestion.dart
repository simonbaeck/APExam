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
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () async {
      Answer toAdd = Answer();
      toAdd.questionId = widget.question.id;
      toAdd.antwoord = textFieldController.text;
      toAdd.studentId = widget.studentId;
      Toaster().showToastMsg("Antwoord opgeslagen");
      Navigator.of(context).pop(toAdd);
      return false;
    },
    child: Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 30.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.question.vraag,
                  style: Styles.headerStyleH2,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: textFieldController,
                  style: const TextStyle(fontSize: 20),
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Antwoord",
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
