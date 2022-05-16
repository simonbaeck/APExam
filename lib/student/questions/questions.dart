import 'dart:async';
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
  const QuestionsScreen({Key? key, required this.currentStudentId})
      : super(key: key);

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> with WidgetsBindingObserver {
  final textFieldController = TextEditingController();

  List<Answer> antwoorden = [];

  static const examMinutes = 60;
  int seconds = Duration(minutes: examMinutes).inSeconds;
  Timer? timer;
  int aantalVragen = 0;
  bool extraTime = false;

  @override
  void initState() {
    if (mounted) {
      super.initState();

      WidgetsBinding.instance?.addObserver(this);

      updateStudent(studentId: widget.currentStudentId);
      getExtraTime();
      startTimer();

      FirebaseFirestore.instance
          .collection("vragen")
          .get()
          .then((querySnapshot) {
        aantalVragen = querySnapshot.size;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
    setState(() {
      timer?.cancel();
    });
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.detached) return;
    final isExited = state == AppLifecycleState.paused;

    if (isExited) {
      updateExitCount();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text('Vragen'),
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
                stream:
                    FirebaseFirestore.instance.collection('vragen').snapshots(),
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

                                  if (antwoorden
                                          .where(
                                              (e) => e.questionId == ds["id"])
                                          .toList()
                                          .isEmpty ==
                                      true) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OpenQuestion(
                                                question: question,
                                                vraag: ds["vraag"],
                                                studentId:
                                                    widget.currentStudentId!,
                                              )),
                                    ).then((value) => antwoorden.add(value));
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OpenQuestion(
                                            question: question,
                                            vraag: ds["vraag"],
                                            studentId: widget.currentStudentId!,
                                            antwoord: antwoorden.singleWhere(
                                                (e) =>
                                                    e.questionId == ds["id"])),
                                      ),
                                    ).then((value) {
                                      if (value != null) {
                                        var index = antwoorden.indexOf(
                                            antwoorden
                                                .where((e) =>
                                                    e.questionId == ds["id"])
                                                .first);
                                        antwoorden[index] = value;
                                      }
                                    });
                                  }
                                } else if (ds["type"] == "correctie") {
                                  Question question = Question();
                                  question.id = ds["id"];
                                  question.vraag = ds["vraag"];
                                  question.type = ds["type"];

                                  if (antwoorden
                                          .where(
                                              (e) => e.questionId == ds["id"])
                                          .toList()
                                          .isEmpty ==
                                      true) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CorrectionQuestion(
                                                vraag: ds["vraag"],
                                                question: question,
                                                studentId:
                                                    widget.currentStudentId!,
                                              )),
                                    ).then((value) => antwoorden.add(value));
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CorrectionQuestion(
                                                question: question,
                                                vraag: ds["vraag"],
                                                studentId:
                                                    widget.currentStudentId!,
                                                antwoord: antwoorden
                                                    .singleWhere((e) =>
                                                        e.questionId ==
                                                        ds["id"])),
                                      ),
                                    ).then((value) {
                                      if (value != null) {
                                        var index = antwoorden.indexOf(
                                            antwoorden
                                                .where((e) =>
                                                    e.questionId == ds["id"])
                                                .first);
                                        antwoorden[index] = value;
                                      }
                                    });
                                  }
                                } else {
                                  MultiChoiceQuestion mquestion =
                                      MultiChoiceQuestion();
                                  mquestion.id = ds["id"];
                                  mquestion.vraag = ds["vraag"];
                                  mquestion.type = ds["type"];
                                  mquestion.antwoorden =
                                      List<String>.from(ds["antwoorden"]);

                                  if (antwoorden
                                          .where(
                                              (e) => e.questionId == ds["id"])
                                          .toList()
                                          .isEmpty ==
                                      true) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MultipleChoiceQuestion(
                                                question: mquestion,
                                                vraag: ds["vraag"],
                                                studentId:
                                                    widget.currentStudentId!,
                                              )),
                                    ).then((value) => antwoorden.add(value));
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MultipleChoiceQuestion(
                                                question: mquestion,
                                                vraag: ds["vraag"],
                                                studentId:
                                                    widget.currentStudentId!,
                                                antwoord: antwoorden
                                                    .singleWhere((e) =>
                                                        e.questionId ==
                                                        ds["id"])),
                                      ),
                                    ).then((value) {
                                      if (value != null) {
                                        var index = antwoorden.indexOf(
                                            antwoorden
                                                .where((e) =>
                                                    e.questionId == ds["id"])
                                                .first);
                                        antwoorden[index] = value;
                                      }
                                    });
                                  }
                                }
                              },
                              child: Card(
                                child: ListTile(
                                    title: Text("Vraag ${index + 1}"),
                                    subtitle: Text("${ds["vraag"]}"),
                                    trailing: antwoorden.contains(antwoorden.firstWhere((e) => e.questionId == ds["id"] && e.studentId == widget.currentStudentId, orElse: () => Answer()))
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          )
                                        : const SizedBox(height: 0.0)),
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
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                  onPressed: antwoorden.where((e) => e.studentId == widget.currentStudentId).length == 3 ? () {
                    addAnswersToDatabase();
                  } : null,
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
      final duration = Duration(seconds: this.seconds);
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      final seconds = this.seconds % 60;

      final hoursString = '$hours'.padLeft(2, '0');
      final minutesString = '$minutes'.padLeft(2, '0');
      final secondsString = '$seconds'.padLeft(2, '0');

      return Row(
        children: <Widget>[
          const Icon(
            Icons.alarm,
          ),
          const SizedBox(width: 6.5),
          Text(
            '$hoursString:$minutesString:$secondsString',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      );
    } else {
      return const SizedBox(height: 0.0);
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (seconds > 0) {
        if (mounted) {
          if (seconds == Duration(minutes: 15).inSeconds) {
            Toaster().showToastMsg("Je hebt nog 15 minuten over!");
          }
          if (seconds == Duration(minutes: 10).inSeconds) {
            Toaster().showToastMsg("Je hebt nog 10 minuten over!");
          }
          if (seconds == Duration(minutes: 5).inSeconds) {
            Toaster().showToastMsg("Je hebt nog 5 minuten over!");
          }
          if (seconds == Duration(minutes: 1).inSeconds) {
            Toaster().showToastMsg("Je hebt nog 1 minuut over!");
          }

          setState(() => seconds--);
        }
      } else {
        addAnswersToDatabase();
      }
    });
  }

  Future updateStudent({required String? studentId}) async {
    final docStudent = FirebaseFirestore.instance.collection("studenten").doc(studentId);
    // Update examen afgelegd
    await docStudent.update({"examActive": true}).catchError((e) => print(e));
    // Update locatie
    await getCurrentLocation().then((Position position) => {
          docStudent.update({
            "studentLocation": GeoPoint(position.latitude, position.longitude)
          }).catchError((e) => print(e))
        });
  }

  Future updateExitCount() async {
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("studenten");
    DocumentReference documentReference = collectionReference.doc(widget.currentStudentId);
    Future<DocumentSnapshot> docSnapshot = documentReference.get();
    int currentExitCount;

    await docSnapshot.then((data) {
      currentExitCount = data["exitedExamCount"];
      documentReference.update({"exitedExamCount": currentExitCount + 1 });
    });
  }

  Future getExtraTime() async {
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("studenten");
    DocumentReference documentReference = collectionReference.doc(widget.currentStudentId);
    Future<DocumentSnapshot> docSnapshot = documentReference.get();

    await docSnapshot.then((data) {
      setState(() {
        if (data['extraTime'] == true) {
          seconds = seconds + Duration(minutes: 20).inSeconds;
        }
      });
    });
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        print("No location possible");
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      forceAndroidLocationManager: true,
    );
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
        _answer.vraag = antwoord.vraag;

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
        emptyAnswer.vraag = "";
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
