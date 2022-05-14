import 'package:flutter/material.dart';
import '../../services/toaster.dart';
import 'answer.class.dart';
import 'multiquestion.class.dart';

class MultipleChoiceQuestion extends StatefulWidget {
  final MultiChoiceQuestion question;
  final String studentId;
  final Answer? antwoord;

  const MultipleChoiceQuestion({Key? key, required this.studentId, required this.question, this.antwoord}) : super(key: key);

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

  late String defaultChoice;
  int defaultIndex = 0;

  Answer toAdd = Answer();

  @override
  void initState() {
    super.initState();
    defaultChoice = widget.question.antwoorden[0];
    if (widget.antwoord != null) {
      defaultChoice = widget.antwoord!.antwoord;
    }
  }

  @override
  Widget multipleChoiceQuestion() {
    return Container(
      child: Column(
        children: [
          Column(
            children: [
              Wrap(
                children: [
                  Container(
                    child: Column(
                      children: widget.question.antwoorden.map((e) => RadioListTile(
                          title: Text(e),
                          value: e.toString(),
                          groupValue: defaultChoice,
                          onChanged: (value) {
                            setState(() {
                              defaultChoice = e;
                            });
                          }
                      )).toList(),
                    ),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              Answer toAdd = Answer();
              toAdd.questionId = widget.question.id;
              toAdd.antwoord = defaultChoice;
              toAdd.studentId = widget.studentId;
              Toaster().showToastMsg("Vraag beantwoord");
              Navigator.of(context).pop(toAdd);
            },
            child: const Text('Beantwoorden'),
          )
        ],
      )
    );
  }
}
