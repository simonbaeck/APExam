import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/student/questions/question.class.dart';
import '../../services/toaster.dart';
import '../../styles/styles.dart';
import 'answer.class.dart';

class CorrectionQuestion extends StatefulWidget {
  final Question question;
  final String studentId;
  final String vraag;
  final Answer? antwoord;

  const CorrectionQuestion(
      {Key? key,
      required this.question,
      required this.studentId,
      required this.vraag,
      this.antwoord})
      : super(key: key);

  @override
  State<CorrectionQuestion> createState() => _CorrectionQuestionState();
}
int score = 0;
class _CorrectionQuestionState extends State<CorrectionQuestion> {
  final textFieldController = TextEditingController();
  late int score;

  @override
  void initState() {
    super.initState();
    setState(() {
      score = 0;
    });
    if (widget.antwoord != null) {
      textFieldController.text = widget.antwoord!.antwoord;
    }
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          Answer toAdd = Answer();
          toAdd.questionId = widget.question.id;
          toAdd.antwoord = textFieldController.text;
          toAdd.studentId = widget.studentId;
          toAdd.vraag = widget.vraag;
          Toaster().showToastMsg("Antwoord opgeslagen");
          setState(() {
            if(identical(widget.question.oplossing.toString().toLowerCase(), toAdd.antwoord.toString().toLowerCase())) {
              score = 1;
            } else {
              score = 0;
            }
          });
          updateScore(studentId: toAdd.studentId, score: score);
          Navigator.of(context).pop(toAdd);

          print(toAdd.antwoord);
          print(widget.question.oplossing);

          if(identical(widget.question.oplossing.toString().toLowerCase(), toAdd.antwoord.toString().toLowerCase())){
            print("juist");
            score++;
            updateScore(studentId: toAdd.studentId, score: score);
          }

          return false;
        },
        child: Scaffold(
          appBar: AppBar(),
          body: correctionQuestion(),
        ),
      );

  Widget correctionQuestion() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 30.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Corrigeer volgende code',
                style: Styles.headerStyleH2,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.grey.shade200,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    widget.question.vraag,
                    style: Styles.codeBlockText,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: textFieldController,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(fontSize: 20, height: 1.35),
                maxLines: null,
                minLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Antwoord",
                ),
              ),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                child: Text(
                  "Antwoord wordt automatisch opgeslagen bij het verlaten van dit scherm.",
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future updateScore({required String? studentId, required int? score}) async {
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("studenten");
    DocumentReference documentReference = collectionReference.doc(studentId);
    Future<DocumentSnapshot> docSnapshot = documentReference.get();

    await docSnapshot.then((data) {
      var curScore = data["score"];
      if (score == 1) {
        documentReference.update({"score": curScore + 1 });
      } else if (score == 0 && curScore > 0) {
        documentReference.update({"score": curScore - 1 });
      } else {
        documentReference.update({"score": curScore });
      }
    });
  }
}
