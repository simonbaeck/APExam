import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/admin/examens/codecorrectie/correctievraag.class.dart';
import 'package:flutter_project/admin/studenten/student.class.dart';
import '../../../services/toaster.dart';
import '../../../styles/styles.dart';

class Addcodecorrectie extends StatefulWidget {
  const Addcodecorrectie({Key? key}) : super(key: key);

  @override
  State<Addcodecorrectie> createState() => _Addcodecorrectie();
}

class _Addcodecorrectie extends State<Addcodecorrectie> {
  final vraagController = TextEditingController();
  final antwoordController = TextEditingController();

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
                "Code correctie toevoegen",
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
                      "Code vraag:",
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
                      hintText: " ",
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    width: double.infinity,
                    child: Text(
                      "Correcte code:",
                      style: Styles.textColorBlack,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: antwoordController,
                    style: const TextStyle(fontSize: 20),
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: " ",
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    alignment: Alignment.topLeft,
                    child: ElevatedButton(
                        onPressed: () {
                          final vraag = vraagController.text;
                          final oplossing = antwoordController.text;
                          addcodecorrectie(
                              inpOpgave: vraag, inpOplossing: oplossing);
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

  Future addcodecorrectie(
      {required String inpOpgave, required String inpOplossing}) async {
    final docVraag =
        FirebaseFirestore.instance.collection("codecorrectie").doc();
    final CorrectieVraag correctieVraag = CorrectieVraag();
    correctieVraag.id = docVraag.id;
    correctieVraag.opgave = inpOpgave;
    correctieVraag.oplossing = inpOplossing;

    await docVraag.set(correctieVraag.toMap()).then((res) {
      Toaster().showToastMsg("vraag toegevoegd");
      Navigator.of(context).pop();
    });
  }
}
