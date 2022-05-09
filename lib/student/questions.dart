import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/admin/studenten/addmultiplestudent.dart';
import 'package:flutter_project/admin/studenten/addstudent.dart';
import 'package:flutter_project/admin/studenten/student.class.dart';
import 'package:flutter_project/admin/studenten/studentdetail.dart';
import 'package:flutter_project/services/loadingscreen.dart';
import 'package:flutter_project/student/questiondetail.dart';
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

class _QuestionsScreenState extends State<QuestionsScreen> {
  Position? _currentPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vragen " + widget.currentStudentId.toString()),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
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
                                  26.0, 30.0, 26.0, 30.0),
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
            ],
          ),
        ),
      ),
    );
  }

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
}
