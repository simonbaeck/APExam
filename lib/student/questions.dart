import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter_project/admin/examens/codecorrectie/correctievraag.class.dart';
import 'package:flutter_project/admin/studenten/addmultiplestudent.dart';
import 'package:flutter_project/admin/studenten/addstudent.dart';
import 'package:flutter_project/admin/studenten/student.class.dart';
import 'package:flutter_project/student/question.class.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/toaster.dart';
import '../styles/styles.dart';

class QuestionsScreen extends StatefulWidget {
  final String? currentStudentId;
  const QuestionsScreen({Key? key, required this.currentStudentId})
      : super(key: key);

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  Stream<List<Question>> readQuestions() => FirebaseFirestore.instance
      .collection('vragen')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Question.fromJson(doc.data())).toList());

  var _questionIndex = 0;
  late List<Question> questions = [];
  final textFieldController = TextEditingController();

  void _answerQuestion() {
    setState(() {
      if (_questionIndex != (questions.length - 1)) {
        _questionIndex = _questionIndex + 1;
      } else {
        Fluttertoast.showToast(
          msg: "Examen voltooid",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.black,
          backgroundColor: Styles.APred.shade900,
          webPosition: "center",
          webBgColor: "#e0e0e0",
          timeInSecForIosWeb: 3,
        );
        ;
        Navigator.of(context).pop();
      }
      textFieldController.text = "";
    });

    @override
    void dispose() {
      // Clean up the controller when the widget is disposed.
      textFieldController.dispose();
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Questions'),
        ),
        body: StreamBuilder<List<Question>>(
            stream: readQuestions(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                questions = snapshot.data!;
                if (questions[_questionIndex].type == "open") {
                  return openQuestion(questions, _questionIndex);
                } else if (questions[_questionIndex].type == "correctie") {
                  return correctionQuestion(questions, _questionIndex);
                } else {
                  return multipleChoiceQuestion(questions, _questionIndex);
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      );

  Widget openQuestion(List<Question> questions, int index) {
    return Container(
      child: Column(
        children: [
          Text(
            questions[index].vraag,
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
              addAnswer(question: questions[index], open: true);
              _answerQuestion();
            },
            child: const Text('Beantwoorden'),
          )
        ],
      ),
    );
  }

  Widget correctionQuestion(List<Question> questions, int index) {
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
            questions[index].vraag,
            style: Styles.textColorBlack,
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
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
              addAnswer(question: questions[index], open: true);
              _answerQuestion();
            },
            child: const Text('Beantwoorden'),
          )
        ],
      ),
    );
  }

  Widget multipleChoiceQuestion(List<Question> questions, int Index) {
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
            questions[Index].vraag,
            style: Styles.headerStyleH1,
          ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: questions[Index].antwoorden.length,
            itemBuilder: (context, index) {
              return CheckboxListTile(
                  title: Text(questions[Index].antwoorden[index]),
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
              _answerQuestion();
            },
            child: const Text('Beantwoorden'),
          )
        ],
      ),
    );
  }

  Future addAnswer({required Question question, required bool open}) async {
    final docAnswer = FirebaseFirestore.instance.collection('antwoorden').doc();
    final Question _question = question;

    _question.studentId = widget.currentStudentId!;
    _question.antwoord = textFieldController.text;

    ///Add to database
    if (open) {
      await docAnswer.set(question.toJsonOpen()).then((res) {
        Toaster().showToastMsg("vraag beantwoord");
      });
    } else {
      await docAnswer.set(question.toJsonMultiple()).then((res) {
        Toaster().showToastMsg("vraag beantwoord");
      });
    }
  }
}
