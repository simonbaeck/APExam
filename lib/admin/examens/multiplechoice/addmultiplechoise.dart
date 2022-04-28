import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/admin/examens/openvraag/vraag.class.dart';
import 'package:flutter_project/admin/studenten/student.class.dart';
import 'package:flutter_project/admin/examens/multiplechoice/multiplechoise.class.dart';
import '../../../services/toaster.dart';
import '../../../styles/styles.dart';

class AddMultplechoice extends StatefulWidget {
  const AddMultplechoice({Key? key}) : super(key: key);

  @override
  State<AddMultplechoice> createState() => _AddMultplechoice();
}

class _AddMultplechoice extends State<AddMultplechoice> {
  final vraagController = TextEditingController();
  final antwoordController = TextEditingController();
  final oplossingController = TextEditingController();

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
                "Multiple choise vraag toevoegen",
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
                  Container(
                    width: double.infinity,
                    child: Text(
                      "Antwoorden:",
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
                      hintText: "Antwoorden moeten gescheiden zijn door een ;",
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    width: double.infinity,
                    child: Text(
                      "Oplossingen",
                      style: Styles.textColorBlack,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: oplossingController,
                    style: const TextStyle(fontSize: 20),
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Kies hier een oplossing",
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    alignment: Alignment.topLeft,
                    child: ElevatedButton(
                        onPressed: () {
                          final vraag = vraagController.text;
                          final antwoord = antwoordController.text.split(";");
                          final oplossing = oplossingController.text;

                          addmuliplechoice(
                              inpOpgave: vraag,
                              inpOplossing: oplossing,
                              inpAntwoord: antwoord);
                          //antwoordController.text.split(";");
                          //print(antwoordController.text.split(";"));
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

  Future addmuliplechoice(
      {required String inpOpgave,
      required String inpOplossing,
      required List<String> inpAntwoord}) async {
    final docVraag = FirebaseFirestore.instance.collection("vragen").doc();
    final Multipechoice multipechoice = Multipechoice();
    multipechoice.id = docVraag.id;
    multipechoice.opgave = inpOpgave;
    multipechoice.oplossing = inpOplossing;
    multipechoice.antwoorden = inpAntwoord;

    await docVraag.set(multipechoice.toMap()).then((res) {
      Toaster().showToastMsg("vraag toegevoegd");
      Navigator.of(context).pop();
    });
  }
}
