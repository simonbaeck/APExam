import 'dart:convert';

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
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final snumController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 30.0),
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
                    controller: firstnameController,
                    style: const TextStyle(fontSize: 20),
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Voornaam",
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: lastnameController,
                    style: const TextStyle(fontSize: 20),
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Achternaam",
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
                          final firstname = firstnameController.text;
                          final lastname = lastnameController.text;
                          final snum = snumController.text;
                          addStudent(inpFirstname: firstname, inpLastname: lastname, inpSnum: snum);
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
    );
  }

  Future addStudent({required String inpFirstname, required String inpLastname, required String inpSnum}) async {
    final docStudent = FirebaseFirestore.instance.collection('studenten').doc();
    final Student student = Student();
    student.id = docStudent.id;
    student.firstName = inpFirstname;
    student.lastName = inpLastname;
    student.sNumber = inpSnum;

    await docStudent.set(student.toMap()).then((res) {
      Toaster().showToastMsg("Student toegevoegd");
      Navigator.of(context).pop();
    });
  }
}
