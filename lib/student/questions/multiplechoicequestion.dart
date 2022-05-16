import 'package:flutter/material.dart';
import '../../services/toaster.dart';
import '../../styles/styles.dart';
import 'answer.class.dart';
import 'multiquestion.class.dart';

class MultipleChoiceQuestion extends StatefulWidget {
  final MultiChoiceQuestion question;
  final String studentId;
  final String vraag;
  final Answer? antwoord;

  const MultipleChoiceQuestion(
      {Key? key,
      required this.studentId,
      required this.question,
      required this.vraag,
      this.antwoord})
      : super(key: key);

  @override
  State<MultipleChoiceQuestion> createState() => _MultipleChoiceQuestionState();
}

class _MultipleChoiceQuestionState extends State<MultipleChoiceQuestion> {
  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          Answer toAdd = Answer();
          toAdd.questionId = widget.question.id;
          toAdd.antwoord = defaultChoice;
          toAdd.studentId = widget.studentId;
          toAdd.vraag = widget.vraag;
          Toaster().showToastMsg("Antwoord opgeslagen");
          Navigator.of(context).pop(toAdd);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Questions'),
          ),
          body: multipleChoiceQuestion(),
        ),
      );

  late String defaultChoice;
  int defaultIndex = 0;

  Answer toAdd = Answer();

  @override
  void initState() {
    super.initState();
    widget.question.antwoorden.insert(0, "");
    defaultChoice = widget.question.antwoorden[0];
    if (widget.antwoord != null) {
      defaultChoice = widget.antwoord!.antwoord;
    }
  }

  @override
  Widget multipleChoiceQuestion() {
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
                widget.question.vraag,
                style: Styles.headerStyleH2,
              ),
              const SizedBox(height: 20),
              Column(
                children: widget.question.antwoorden
                    .map((e) => RadioListTile(
                        title: Text(e),
                        value: e.toString(),
                        groupValue: defaultChoice,
                        onChanged: (value) {
                          setState(() {
                            defaultChoice = e;
                          });
                        }))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
