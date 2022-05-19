import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/admin/studenten/student.class.dart';
import '../../services/toaster.dart';
import '../../styles/styles.dart';
import 'answer.class.dart';
import 'multiquestion.class.dart';

class MultipleChoiceQuestion extends StatefulWidget {
  final MultiChoiceQuestion question;
  final String studentId;
  final String vraag;
  final Answer? antwoord;
  final bool isCorrect = false;


  const MultipleChoiceQuestion(
      {Key? key,
      required this.studentId,
      required this.question,
      required this.vraag,
      this.antwoord})
      : super(key: key);

  @override
  State<MultipleChoiceQuestion> createState() => _MultipleChoiceQuestionState();
}

class _MultipleChoiceQuestionState extends State<MultipleChoiceQuestion> {
  late int score;

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          Answer toAdd = Answer();
          toAdd.questionId = widget.question.id;
          toAdd.antwoord = defaultChoice;
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
          //calculate score
          if(widget.question.oplossing == toAdd.antwoord){

            //Update score
            score++;
            updateScore(studentId: toAdd.studentId, score: score);
          } else {
            print("Fout");
          }

          return false;


        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Questions'),
          ),
          body: multipleChoiceQuestion(),
        ),
      );


  late String defaultChoice;
  int defaultIndex = 0;

  Answer toAdd = Answer();

  @override
  void initState() {
    super.initState();
    setState(() {
      score = 0;
    });
    widget.question.antwoorden.insert(0, "");
    defaultChoice = widget.question.antwoorden[0];
    if (widget.antwoord != null) {
      defaultChoice = widget.antwoord!.antwoord;
    }

  }

  @override
  Widget multipleChoiceQuestion() {
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
                widget.question.vraag,
                style: Styles.headerStyleH2,
              ),
              const SizedBox(height: 20),
              Column(
                children: widget.question.antwoorden
                    .map((e) => RadioListTile(
                        title: Text(e),
                        value: e.toString(),
                        groupValue: defaultChoice,
                        onChanged: (value) {
                          setState(() {
                            defaultChoice = e;
                          });
                        }))
                    .toList(),
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
