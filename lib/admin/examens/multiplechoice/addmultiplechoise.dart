import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/admin/examens/openvraag/openvraag.class.dart';
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

  bool isButtonStep1Disabled = true;
  bool hasContinued = false;
  Map<String, bool> checklist = {};

  @override
  void dispose() {
    antwoordController.dispose();
    super.dispose();
  }

  void onValueChange() {
    setState(() {
      antwoordController.text;
      if (antwoordController.text.isEmpty && hasContinued) {
        hasContinued = false;
        checklist = {};
      }

      antwoordController.text.split(";").length > 1 ? isButtonStep1Disabled = false : isButtonStep1Disabled = true;
    });
  }

  @override
  void initState() {
    super.initState();
    antwoordController.addListener(onValueChange);
  }

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
                  !hasContinued ? Container(
                    alignment: Alignment.topLeft,
                    child: ElevatedButton(
                        onPressed: isButtonStep1Disabled ? null : () => createMap(answers: antwoordController.text),
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
                        child: Text("selecteer antwoorden".toUpperCase())),
                  ) : const SizedBox(height: 0.0),
                  hasContinued ? Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Selecteer hieronder de juiste antwoorden op de multiple choice vraag",
                          style: Styles.textColorBlack,
                        ),
                        const SizedBox(height: 10.0),
                        ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: checklist.length,
                            itemBuilder: (context, index) {
                              return CheckboxListTile(
                                title: Text(checklist.keys.elementAt(index)),
                                value: checklist.values.elementAt(index),
                                controlAffinity: ListTileControlAffinity.leading,
                                selectedTileColor: Styles.APred.shade50,
                                selected: checklist.values.elementAt(index),
                                onChanged: (bool? val) {
                                  setState(() {
                                    checklist.update(checklist.keys.elementAt(index), (value) => val!);
                                  });
                                },
                              );
                            }
                        ),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                            onPressed: () => {
                              addmuliplechoice(
                                  inpOpgave: vraagController.text,
                              )
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
                            child: Text("vraag toevoegen".toUpperCase())
                        ),
                      ],
                    ),
                  ) : const SizedBox(height: 0.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future addmuliplechoice({required String inpOpgave}) async {
    final docVraag = FirebaseFirestore.instance.collection("vragen").doc();
    final Multipechoice multipechoice = Multipechoice();

    multipechoice.id = docVraag.id;
    multipechoice.opgave = inpOpgave;
    multipechoice.type = "multiplechoice";

    List<String> antwoorden = [];
    for (var i = 0; i < checklist.length; i++) {
      antwoorden.add(checklist.keys.elementAt(i));
    }
    multipechoice.antwoorden = antwoorden;

    List<int> oplossingen = [];
    for (var i = 0; i < checklist.length; i++) {
      if (checklist.values.elementAt(i) == true) {
        oplossingen.add(i);
      }
    }
    multipechoice.oplossingen = oplossingen;

    await docVraag.set(multipechoice.toMap()).then((res) {
      Toaster().showToastMsg("vraag toegevoegd");
      Navigator.of(context).pop();
    });
  }

  createMap({ required String answers }) {
    answers.split(";").forEach((element) {
      checklist[element] = false;
    });

    setState(() {
      hasContinued = true;
    });
  }

}
