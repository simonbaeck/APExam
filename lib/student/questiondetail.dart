import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../styles/styles.dart';

class QuestionDetail extends StatefulWidget {
  final DocumentSnapshot question;
  const QuestionDetail({Key? key, required this.question}) : super(key: key);

  @override
  State<QuestionDetail> createState() => _QuestionDetailState();
}

class _QuestionDetailState extends State<QuestionDetail> {
  bool isChecked = false;
  final answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Question"),
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
                "Answer:",
                style: Styles.textColorBlack,
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: answerController,
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
                    final oplossing = answerController.text;
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
                  child: Text("Answer".toUpperCase())),
            ),
          ],
        ),
      ),
    );
  }
}
