import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/admin/studenten/student.class.dart';
import '../../services/toaster.dart';
import '../../styles/styles.dart';

class AddOpenvraag extends StatefulWidget {
  const AddOpenvraag({Key? key}) : super(key: key);

  @override
  State<AddOpenvraag> createState() => _AddOpenvraag();
}

class _AddOpenvraag extends State<AddOpenvraag> {
  final vraagController = TextEditingController();

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
                "Open vraag toevoegen",
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
                      "Vraag:",
                      style: Styles.textColorBlack,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: vraagController,
                    style: const TextStyle(fontSize: 20),
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Kies hier een vraag",
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const SizedBox(height: 20.0),
                  Container(
                    alignment: Alignment.topLeft,
                    child: ElevatedButton(
                        onPressed: () {
                          final firstname = vraagController.text;

                          /*
                          addStudent(
                              inpFirstname: firstname,
                              inpLastname: lastname,
                              inpSnum: snum);*/
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
                        child: Text("Vraag toevoegen".toUpperCase())),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
/*
  Future addStudent(
      {required String inpFirstname,
      required String inpLastname,
      required String inpSnum}) async {
    final docStudent = FirebaseFirestore.instance.collection('studenten').doc();
    final Student student = Student();
    student.id = docStudent.id;
    student.firstname = inpFirstname;
    student.lastname = inpLastname;
    student.snumber = inpSnum;
  }*/
}
