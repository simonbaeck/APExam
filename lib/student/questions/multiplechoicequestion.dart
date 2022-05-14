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

  Widget multipleChoiceQuestion() {
    final List checked = [];
    bool isChecked = true;

    void _onAnswerSelected(bool selected, antwoord) {
      if (selected == true) {
        setState(() {
          checked.add(antwoord);
        });
      } else {
        setState(() {
          checked.remove(antwoord);
        });
      }
    }

    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            widget.question.vraag,
            style: Styles.headerStyleH1,
          ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: widget.question.antwoorden.length,
            itemBuilder: (context, index) {
              return CheckboxListTile(
                  title: Text(widget.question.antwoorden[index]),
                  controlAffinity: ListTileControlAffinity.leading,
                  selectedTileColor: Styles.APred.shade50,
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                    });
                  });
            },
          ),
          ElevatedButton(
            onPressed: () {
              print(checked);
            },
            child: const Text('Beantwoorden'),
          )
        ],
      ),
    );
  }
}
