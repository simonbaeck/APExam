import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/styles/styles.dart';

import 'package:flutter_project/student/questions.dart';

import '../admin/studenten/student.class.dart';

// class Student {
//   late int id;
//   late String name;
//
//   Student(int id, String name) {
//     this.id = id;
//     this.name = name;
//   }
//
//   @override
//   String toString() {
//     return '{ id: $id, name: $name }';
//   }
// }

class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({Key? key}) : super(key: key);

  @override
  _StudentLoginScreenState createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
  bool _isButtonDisabled = true;
  String? studentId;

  printObj() {
    print(studentId);
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
                          return DropdownButtonFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              filled: false,
                            ),
                            items: snapshot.data?.docs.map((student) {
                              return DropdownMenuItem(
                                child: Text(
                                    "${student.get('snumber')} [${student.get('firstname')} ${student.get('lastname')}]"),
                                value: student.get('id').toString(),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                studentId = value.toString();
                                _isButtonDisabled = false;
                              });
                            },
                            value: studentId,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      alignment: Alignment.topLeft,
                      child: ElevatedButton(
                          onPressed: _isButtonDisabled ? null : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QuestionsScreen(currentStudentId: studentId)),
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
}
