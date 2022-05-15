import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Answer {
  late String type;
  late String vraag;
  late String studentId;
  late String antwoord = "";
  late List<String> antwoorden = [];
  late int punt;

  Answer({
    required this.type,
    required this.studentId,
    required this.antwoord,
    required this.antwoorden,
  });

  static Answer fromJson(Map<String, dynamic> json) {
    if (json['antwoorden'] != null) {
      return Answer(
        studentId: json['studentId'],
        type: json['type'],
        //vraag: json['vraag'],
        antwoorden: List.from(
          json['antwoorden'],
        ),
        antwoord: "",
      );
    } else {
      return Answer(
          studentId: json['studentId'],
          type: json['type'],
          //vraag: json['vraag'],
          antwoord: "",
          antwoorden: [""]);
    }
  }
}
