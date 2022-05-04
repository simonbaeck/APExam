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
          ],
        ),
      ),
    );
  }
}
