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
  const QuestionsScreen({Key? key}) : super(key: key);

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

  void _answerQuestion() {
    setState(() {
      if (_questionIndex != (questions.length - 1)) {
        _questionIndex = _questionIndex + 1;
      }
    });
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
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Antwoord',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _answerQuestion();
            },
            child: const Text('Next'),
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
            questions[index].vraag,
            style: Styles.headerStyleH1,
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Correctie',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _answerQuestion();
            },
            child: const Text('Next'),
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
            child: const Text('Next'),
          )
        ],
      ),
    );
  }
}
