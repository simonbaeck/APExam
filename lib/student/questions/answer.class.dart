class Answer {
  String? id;
  late String studentId;
  late String questionId;
  late String antwoord;
  late String vraag;
  late int score;

  Map<String, dynamic> toMap() => {
        'id': id,
        'studentId': studentId,
        'questionId': questionId,
        'antwoord': antwoord,
        'vraag': vraag,

      };

  @override
  String toString() {
    return 'Answer { id: $id, studentId: $studentId, questionId: $questionId, antwoord: $antwoord}';
  }
}
