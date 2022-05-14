import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/admin/examens/multiplechoice/multiplechoise.class.dart';
import 'package:flutter_project/student/questions/correctionquestion.dart';
import 'package:flutter_project/student/questions/multiplechoicequestion.dart';
import 'package:flutter_project/student/questions/openquestion.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_project/student/questions/question.class.dart';
import '../../services/toaster.dart';
import '/styles/styles.dart';

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
                return questionsList(questions);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      );

  Widget questionsList(List<Question> questions) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(26.0, 30.0, 26.0, 30.0),
      shrinkWrap: true,
      controller: ScrollController(),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            print("tap");
            if (questions[index].type == 'open') {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OpenQuestion(
                          question: questions[index],
                        )),
              );
            } else if (questions[index].type == 'correctie') {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CorrectionQuestion(
                          question: questions[index],
                        )),
              );
            } else if (questions[index].type == "multiplechoice") {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MultipleChoiceQuestion(
                          question: questions[index],
                        )),
              );
            }
          },
          child: Card(
            child: ListTile(
              title: Text(questions[index].vraag),
            ),
          ),
        );
      },
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
