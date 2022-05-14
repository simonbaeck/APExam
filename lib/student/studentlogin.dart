import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/student/questions/questions.dart';
import 'package:flutter_project/styles/styles.dart';
import 'package:simple_timer/simple_timer.dart';
import '../admin/studenten/student.class.dart';

class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({Key? key}) : super(key: key);

  @override
  _StudentLoginScreenState createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
  bool _isButtonDisabled = true;
  String? studentId;

  @override
  void initState() {
    super.initState();
    getExtraTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.fromLTRB(30.0, 45.0, 30.0, 30.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: ListView(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  '../assets/AP_logo.png',
                  width: 110.0,
                  height: 64.78,
                ),
              ),
              const SizedBox(height: 45.0),
              Container(
                width: double.infinity,
                child: Text(
                  "Hallo, student",
                  style: Styles.headerStyleH1,
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                child: Text(
                  "Vul hieronder je studentennummer in om te starten.",
                  style: Styles.textColorBlack,
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                child: Column(
                  children: <Widget>[
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('studenten')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          _isButtonDisabled = true;
                          return const CircularProgressIndicator();
                        } else {
                          if (snapshot.data?.docs.where((e) => e.get('examActive') == false).toList().isEmpty == true) {
                            return Container(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Alle studenten hebben het examen afgelegd, of het examen is afgelopen!",
                                    style: TextStyle(
                                      color: Styles.APred,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  )
                                ],
                              ),
                            );
                          } else {
                            return DropdownButtonFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                filled: false,
                              ),
                              items: snapshot.data?.docs
                                  .where((e) => e.get('examActive') == false)
                                  .map((student) {
                                return DropdownMenuItem(
                                  child: Text(
                                      "${student.get('sNumber')} [${student.get('firstName')} ${student.get('lastName')}]"),
                                  value: student.get('id'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  studentId = value.toString();
                                  _isButtonDisabled = false;
                                });
                              },
                              value: snapshot.data?.docs.where((e) => e.get('examActive') == false).toList().where((e) => e.id == studentId).length == 1 ? studentId : null,
                            );
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      alignment: Alignment.topLeft,
                      child: ElevatedButton(
                          onPressed: _isButtonDisabled
                              ? null
                              : () {
                            setState(() {
                              _isButtonDisabled = true;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QuestionsScreen(
                                      currentStudentId: studentId)),
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
                          child: Text("Naar examen".toUpperCase())),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTimer() {
    return Text("Hier");
  }

  Future<bool> getExtraTime() async {
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("studenten");
    DocumentReference documentReference = collectionReference.doc("0DfDwQsTHcCQNarYbT8O");
    Future<DocumentSnapshot> docSnapshot = documentReference.get();

    return await docSnapshot.then((data) {
      if (data['extraTime'] == false) {
        return false;
      } else {
        return true;
      }
    });
  }
}
