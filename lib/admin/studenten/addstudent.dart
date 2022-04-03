import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/admin/studenten/student.class.dart';

import '../../services/toaster.dart';
import '../../styles/styles.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({Key? key}) : super(key: key);

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final nameController = TextEditingController();
  final snumController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.fromLTRB(30.0, 45.0, 30.0, 30.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Text(
                  "Student toevoegen",
                  style: Styles.headerStyleH1,
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      child: Text(
                        "Vul hieronder de naam van de student in",
                        style: Styles.textColorBlack,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: nameController,
                      style: const TextStyle(fontSize: 20),
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Voornaam Achternaam",
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      width: double.infinity,
                      child: Text(
                        "Vul hieronder het s-nummer van de student in",
                        style: Styles.textColorBlack,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: snumController,
                      style: const TextStyle(fontSize: 20),
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "s122823",
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      alignment: Alignment.topLeft,
                      child: ElevatedButton(
                          onPressed: () {
                            final name = nameController.text;
                            final snum = snumController.text;
                            addStudent(inpName: name, inpSnum: snum);
                          },
                          style: ButtonStyle(
                            textStyle: MaterialStateProperty.all(
                              const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            minimumSize:
                            MaterialStateProperty.all(const Size(double.infinity, 65)),
                          ),
                          child: Text("toevoegen".toUpperCase())),
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

  Future addStudent({required String inpName, required String inpSnum}) async {
    try {
      final docStudent = FirebaseFirestore.instance.collection('studenten').doc();
      final splitName = inpName.split(' ');
      final Student student = Student(docStudent.id, splitName[0], splitName[1], inpSnum);
      await docStudent.set(student.toMap());
    } on FirebaseException catch (e) {
      Toaster().showToastMsg(e.message);
    }
  }
}
