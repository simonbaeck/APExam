import 'dart:async';
import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/student/questions/correctionquestion.dart';
import 'package:flutter_project/student/questions/multiplechoicequestion.dart';
import 'package:flutter_project/student/questions/multiquestion.class.dart';
import 'package:flutter_project/student/questions/openquestion.dart';
import 'package:flutter_project/student/questions/question.class.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/loader.dart';
import '../../services/toaster.dart';
import 'answer.class.dart';

class QuestionsScreen extends StatefulWidget {
  final String? currentStudentId;
  const QuestionsScreen({Key? key, required this.currentStudentId}) : super(key: key);

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  final textFieldController = TextEditingController();

  List<Answer> antwoorden = [];

  static const maxSeconds = 60;
  int seconds = maxSeconds;
  Timer? timer;
  int aantalVragen = 0;

  @override
  void initState() {
    if (mounted) {
      super.initState();
      updateStudent(studentId: widget.currentStudentId);
      startTimer();

      FirebaseFirestore.instance.collection("vragen").get().then((querySnapshot) {
        aantalVragen = querySnapshot.size;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    setState(() {
      timer?.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text('Questions'),
            buildTimer(),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 30.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('vragen').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Error");
                  } else if (!snapshot.hasData) {
                    return const LoaderWidget(loaderText: "Laden...");
                  } else {
                    if (snapshot.data!.docs.isNotEmpty) {
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          controller: ScrollController(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot ds = snapshot.data!.docs[index];
                            return GestureDetector(
                              onTap: () {
                                if (ds["type"] == "open") {
                                  Question question = Question();
                                  question.id = ds["id"];
                                  question.vraag = ds["vraag"];
                                  question.type = ds["type"];

                                  if (antwoorden.where((e) => e.questionId == ds["id"]).toList().isEmpty == true) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OpenQuestion(
                                            question: question,
                                            studentId: widget.currentStudentId!,
                                          )),
                                    ).then((value) => antwoorden.add(value));
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OpenQuestion(
                                            question: question,
                                            studentId: widget.currentStudentId!,
                                            antwoord: antwoorden.singleWhere((e) => e.questionId == ds["id"])),
                                          ),
                                    ).then((value) {
                                      if (value != null) {
                                        var index = antwoorden.indexOf(antwoorden.where((e) => e.questionId == ds["id"]).first);
                                        antwoorden[index] = value;
                                      }
                                    });
                                  }
                                } else if (ds["type"] == "correctie") {
                                  Question question = Question();
                                  question.id = ds["id"];
                                  question.vraag = ds["vraag"];
                                  question.type = ds["type"];

                                  if (antwoorden.where((e) => e.questionId == ds["id"]).toList().isEmpty == true) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CorrectionQuestion(
                                            question: question,
                                            studentId: widget.currentStudentId!,
                                          )),
                                    ).then((value) => antwoorden.add(value));
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CorrectionQuestion(
                                            question: question,
                                            studentId: widget.currentStudentId!,
                                            antwoord: antwoorden.singleWhere((e) => e.questionId == ds["id"])),
                                      ),
                                    ).then((value) {
                                      if (value != null) {
                                        var index = antwoorden.indexOf(antwoorden.where((e) => e.questionId == ds["id"]).first);
                                        antwoorden[index] = value;
                                      }
                                    });
                                  }
                                } else {
                                  MultiChoiceQuestion mquestion = MultiChoiceQuestion();
                                  mquestion.id = ds["id"];
                                  mquestion.vraag = ds["vraag"];
                                  mquestion.type = ds["type"];
                                  mquestion.antwoorden = List<String>.from(ds["antwoorden"]);

                                  if (antwoorden.where((e) => e.questionId == ds["id"]).toList().isEmpty == true) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MultipleChoiceQuestion(
                                            question: mquestion,
                                            studentId: widget.currentStudentId!,
                                          )),
                                    ).then((value) => antwoorden.add(value));
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MultipleChoiceQuestion(
                                            question: mquestion,
                                            studentId: widget.currentStudentId!,
                                            antwoord: antwoorden.singleWhere((e) => e.questionId == ds["id"])),
                                      ),
                                    ).then((value) {
                                      if (value != null) {
                                        var index = antwoorden.indexOf(antwoorden.where((e) => e.questionId == ds["id"]).first);
                                        antwoorden[index] = value;
                                      }
                                    });
                                  }
                                }
                              },
                              child: Card(
                                child: ListTile(
                                  title: Text("${ds["vraag"]}"),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return const SizedBox(height: 0.0);
                    }
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                    onPressed: () {
                      print(antwoorden);
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
                    child: Text("check answers".toUpperCase())),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                    onPressed: () {
                      addAnswersToDatabase();
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
                    child: Text("examen indienen".toUpperCase())),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTimer() {
    if (mounted) {
      return Text('Resterende tijd: $seconds');
    } else {
      return const SizedBox(height: 0.0);
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (seconds > 0) {
        if (mounted) {
          setState(() => seconds--);
        }
      } else {
        addAnswersToDatabase();
      }
    });
  }

  Future updateStudent({required String? studentId}) async {
    final docStudent =
    FirebaseFirestore.instance.collection("studenten").doc(studentId);
    // Update examen afgelegd
    docStudent.update({"examActive": false}).catchError((e) => print(e));
    // Update locatie
    getCurrentLocation().then((Position position) => {
      docStudent.update({
        "studentLocation": GeoPoint(position.latitude, position.longitude)
      }).catchError((e) => print(e))
    });
  }

  Future<bool> getExtraTime() async {
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("studenten");
    DocumentReference documentReference = collectionReference.doc(widget.currentStudentId);
    Future<DocumentSnapshot> docSnapshot = documentReference.get();

    return await docSnapshot.then((data) {
      if (data['extraTime'] == false) {
        return false;
      } else {
        return true;
      }
    });
  }

  Future<Position> getCurrentLocation() {
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  }

  Future addAnswersToDatabase() async {
    try {
      for (var antwoord in antwoorden) {
        final docAnswer = FirebaseFirestore.instance.collection('antwoorden').doc();
        final Answer _answer = Answer();

        _answer.id = docAnswer.id;
        _answer.questionId = antwoord.questionId;
        _answer.studentId = antwoord.studentId;
        _answer.antwoord = antwoord.antwoord;

        await docAnswer.set(_answer.toMap());
      }

      var aantalVragenBeantwoord = antwoorden.where((e) => e.studentId == widget.currentStudentId).length;
      for (var i = 0; i < aantalVragen - aantalVragenBeantwoord; i++) {
        final docAnswer = FirebaseFirestore.instance.collection('antwoorden').doc();
        final Answer emptyAnswer = Answer();
        emptyAnswer.id = docAnswer.id;
        emptyAnswer.studentId = widget.currentStudentId!;
        emptyAnswer.questionId = "";
        emptyAnswer.antwoord = "";
        await docAnswer.set(emptyAnswer.toMap());
      }

      Toaster().showToastMsg("Examen ingediend");
      setState(() {
        timer?.cancel();
      });
      Navigator.of(context).pop();
    } on FirebaseException catch (ex) {
      Toaster().showToastMsg(ex);
    }
  }
}
