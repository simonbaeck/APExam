import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Answer {
  late String type;
  late String vraag;
  late String studentId;
  late String antwoord = "";
  late int score;

  Answer({
    required this.studentId,
    required this.antwoord,
    required this.vraag,
  });

  static Answer fromJson(Map<String, dynamic> json) {
    return Answer(
      studentId: json['studentId'],
      vraag: json['vraag'],
      antwoord: json['antwoord'],

    );
  }
}
