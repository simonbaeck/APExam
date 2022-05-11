import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_project/student/answer.class.dart';

import '../../styles/styles.dart';
import '../services/toaster.dart';

class QuestionDetail extends StatefulWidget {
  final DocumentSnapshot question;
  final String currentStudentId;
  const QuestionDetail(
      {Key? key, required this.currentStudentId, required this.question})
      : super(key: key);

  @override
  State<QuestionDetail> createState() => _QuestionDetailState();
}

class _QuestionDetailState extends State<QuestionDetail> {
  final answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vraag"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 30.0),
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  Text(
                    widget.question["vraag"].toString(),
                    style: Styles.headerStyleH1,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              child: Text(
                "Antwoord:",
                style: Styles.textColorBlack,
              ),
            ),
            const SizedBox(height: 20.0),
            if (widget.question["type"] == "open")
              TextFormField(
                controller: answerController,
                style: const TextStyle(fontSize: 20),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Antwoord",
                ),
              ),
            if (widget.question["type"] == "correctie")
              TextFormField(
                controller: answerController,
                style: const TextStyle(fontSize: 20),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Antwoord",
                ),
              ),
            if (widget.question["type"] == "multiplechoice")
              SizedBox(
                height: 400.0,
                child: ListView.builder(
                  itemCount: (widget.question["antwoorden"]).length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                        title: Text("${widget.question["antwoorden"][index]}"),
                        value: false,
                        onChanged: (bool? val) {});
                  },
                ),
              ),
            const SizedBox(height: 20.0),
            Container(
              alignment: Alignment.topLeft,
              child: ElevatedButton(
                  onPressed: () {
                    final antwoord = answerController.text;
                    addAnswer(antwoord: antwoord);
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
                  child: Text("Beantwoord".toUpperCase())),
            ),
          ],
        ),
      ),
    );
  }

  Future addAnswer({required String antwoord}) async {
    final docAnswer = FirebaseFirestore.instance.collection('antwoorden').doc();
    final Answer answer = Answer();
    answer.id = docAnswer.id;
    answer.studentId = widget.currentStudentId;
    answer.questionId = widget.question.id;
    answer.answer = antwoord;

    await docAnswer.set(answer.toMap()).then((res) {
      Toaster().showToastMsg("antwoord toegevoegd");
      Navigator.of(context).pop();
    });
  }
}
