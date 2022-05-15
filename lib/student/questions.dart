import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/admin/studenten/addmultiplestudent.dart';
import 'package:flutter_project/admin/studenten/addstudent.dart';
import 'package:flutter_project/admin/studenten/student.class.dart';
import 'package:flutter_project/admin/studenten/studentdetail.dart';
import 'package:flutter_project/services/loadingscreen.dart';
import 'package:flutter_project/student/questiondetail.dart';
import 'package:flutter_project/student/studentlogin.dart';
import 'package:flutter_project/styles/styles.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geolocator/geolocator.dart';

import '../../services/toaster.dart';

class QuestionsScreen extends StatefulWidget {
  final String? currentStudentId;
  const QuestionsScreen({Key? key, required this.currentStudentId})
      : super(key: key);

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print("didChangeAppLifecycleState is called");
  }

  Stream<List<Question>> readQuestions() => FirebaseFirestore.instance
      .collection('vragen')
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) => Question.fromJson(doc.data())).toList());

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;

    final isBackground = state == AppLifecycleState.paused;

    if (isBackground) {
      print("Is closed");
    }
  }

  @override
  void dispose() {
    print("dispose is called");
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

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

  Position? _currentPosition;

  /*@override
  Widget build(BuildContext context) {
    print("build is called");
    return Scaffold(
      appBar: AppBar(
        title: Text("Vragen " + widget.currentStudentId.toString()),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Align(
          alignment: Alignment.topLeft,
          child: ListView(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('vragen')
                    .orderBy('id', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Error");
                  } else if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return snapshot.data!.docs.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.fromLTRB(
                                  30.0, 45.0, 30.0, 30.0),
                              shrinkWrap: true,
                              controller: ScrollController(),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot ds =
                                    snapshot.data!.docs[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => QuestionDetail(
                                                question: ds,
                                                currentStudentId: widget
                                                    .currentStudentId
                                                    .toString(),
                                              )),
                                    );
                                  },
                                  child: Card(
                                    child: ListTile(
                                      title: Text("${ds["vraag"]}"),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.fromLTRB(
                                26.0, 30.0, 26.0, 30.0),
                            child: const Card(
                              child: ListTile(
                                title: Text("Er zijn geen vragen gevonden"),
                              ),
                            ),
                          );
                  }
                },
              ),
              Container(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StudentLoginScreen()),
                      );
                    },
                    style: ButtonStyle(
                      textStyle: MaterialStateProperty.all(
                        const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all(
                          const Size(double.infinity, 65)),
                    ),
                    child: Text("Examen afronden".toUpperCase())),
              ),
            ],
          ),
        ),
      ),
    );
  }*/

  @override
  void initState() {
    super.initState();
    print("initState is called");
    WidgetsBinding.instance?.addObserver(this);
    updateStudent(studentId: widget.currentStudentId);
  }

  Future updateStudent({required String? studentId}) async {
    final docStudent =
        FirebaseFirestore.instance.collection("studenten").doc(studentId);
    // Update examen afgelegd
    docStudent.update({"examActive": true}).catchError((e) => print(e));
    // Update locatie
    getCurrentLocation().then((Position position) => {
          docStudent.update({
            "studentLocation": GeoPoint(position.latitude, position.longitude)
          }).catchError((e) => print(e))
        });
  }

  Future<Position> getCurrentLocation() {
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

  @override
  void initState() {
    super.initState();
    updateStudent(studentId: widget.currentStudentId);
  }

  Future updateStudent({required String? studentId}) async {
    final docStudent =
    FirebaseFirestore.instance.collection("studenten").doc(studentId);
    // Update examen afgelegd
    docStudent.update({"examActive": true}).catchError((e) => print(e));
    // Update locatie
    getCurrentLocation().then((Position position) => {
      docStudent.update({
        "studentLocation": GeoPoint(position.latitude, position.longitude)
      }).catchError((e) => print(e))
    });
  }

  Future<Position> getCurrentLocation() {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
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