import 'package:flutter/material.dart';
import 'package:flutter_project/student/questions/question.class.dart';
import '../../services/toaster.dart';
import '../../styles/styles.dart';
import 'answer.class.dart';

class CorrectionQuestion extends StatefulWidget {
  final Question question;
  final String studentId;
  final String vraag;
  final Answer? antwoord;

  const CorrectionQuestion(
      {Key? key,
      required this.question,
      required this.studentId,
      required this.vraag,
      this.antwoord})
      : super(key: key);

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
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          Answer toAdd = Answer();
          toAdd.questionId = widget.question.id;
          toAdd.antwoord = textFieldController.text;
          toAdd.studentId = widget.studentId;
          toAdd.vraag = widget.vraag;
          Toaster().showToastMsg("Antwoord opgeslagen");
          Navigator.of(context).pop(toAdd);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(),
          body: correctionQuestion(),
        ),
      );

  Widget correctionQuestion() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 30.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Corrigeer volgende code:',
                style: Styles.headerStyleH2,
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
              TextField(
                controller: textFieldController,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(fontSize: 20, height: 1.35),
                maxLines: null,
                minLines: 3,
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
    );
  }
}
