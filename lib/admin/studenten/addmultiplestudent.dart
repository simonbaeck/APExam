import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/admin/studenten/student.class.dart';
import 'package:flutter_project/services/loader.dart';

import '../../services/toaster.dart';
import '../../styles/styles.dart';

class AddMultipleStudent extends StatefulWidget {
  const AddMultipleStudent({Key? key}) : super(key: key);

  @override
  State<AddMultipleStudent> createState() => _AddMultipleStudentState();
}

class _AddMultipleStudentState extends State<AddMultipleStudent> {
  final csvInputController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 30.0),
        child: !isLoading ? Column(
          children: [
            Container(
              width: double.infinity,
              child: Text(
                "Voeg meerdere studenten toe",
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
                      "Plak hieronder de inhoud van het CSV bestand.",
                      style: Styles.textColorBlack,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    width: double.infinity,
                    child: Text(
                      "Formaat: <voornaam>;<achternaam>;<snummer>",
                      style: Styles.textColorBlack,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: csvInputController,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(fontSize: 20, height: 1.35),
                    maxLines: null,
                    minLines: 5,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "john;doe;s569874\nanna;bolen;s897456",
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    alignment: Alignment.topLeft,
                    child: ElevatedButton(
                        onPressed: () {
                          final csv = csvInputController.text;
                          addStudents(inpCsv: csv);
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
        ) : const LoaderWidget(loaderText: "Studenten toevoegen..."),
      ),
    );
  }

  Future addStudents({required String inpCsv}) async {
    setState(() {
      isLoading = true;
    });

    List<List<String>> studentList = [];
    int counter1 = 0;
    List<String> temp = [];
    inpCsv.replaceAll("\n", ";").split(';').asMap().forEach((index, value) {
      temp.add(value);
      counter1++;
      if (counter1 == 3) {
        studentList.add(temp);
        temp = [];
        counter1 = 0;
      }
    });

    int counter2 = 0;
    studentList.asMap().forEach((index, item) {
      final docStudent = FirebaseFirestore.instance.collection('studenten').doc();
      Student student = Student();
      student.id = docStudent.id;
      student.firstName = item[0];
      student.lastName = item[1];
      student.sNumber = item[2];

      docStudent.set(student.toMap()).whenComplete(() {
        student = Student();
        counter2++;
        if (counter2 == studentList.length) {
          setState(() {
            isLoading = false;
          });
          Toaster().showToastMsg("${studentList.length} studenten toegevoegd");
          counter2 = 0;
          studentList = [];
          Navigator.of(context).pop();
        }
      });
    });
  }
}

/*
John;Doe;s111111
Edward;Delacerda;s469521
William;Cooper;s746931
Stephen;Morgan;s367491
Kevin;Carver;s851379
Hazel;Bailey;s761349
Donald;Beebe;s713982
Michael;Huynh;s766954
Virginia;Wan;s897461
John;Rutledge;s482615
Muriel;Butner;s763149
Arthur;Zambrano;s886314
Susan;Smith;s773199
Jessica;Riggins;s615524
Martha;Barnette;s966351
*/
