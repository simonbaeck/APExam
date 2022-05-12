import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
              addAnswer(question: questions[index]);
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
              addAnswer(question: questions[index]);
              _answerQuestion();
            },
            child: const Text('Beantwoorden'),
          )
        ],
      ),
    );
  }

  Widget multipleChoiceQuestion(List<Question> questions, int index) {
    return Container(
      child: Column(
        children: [
          Text(
            questions[index].vraag,
            style: Styles.headerStyleH1,
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'multiple',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _answerQuestion();
            },
            child: const Text('Beantwoorden'),
          )
        ],
      ),
    );
  }

  Future addAnswer({required Question question}) async {
    final docAnswer = FirebaseFirestore.instance.collection('antwoorden').doc();
    final Question _question = question;

    _question.studentId = widget.currentStudentId!;
    _question.antwoord = textFieldController.text;

    ///Add to database
    /*await docAnswer.set(question.toJson()).then((res) {
      Toaster().showToastMsg("antwoord toegevoegd");
    });*/
  }
}
