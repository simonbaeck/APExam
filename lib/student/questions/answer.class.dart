class Answer {
  String? id;
  late String studentId;
  late String questionId;
  late String antwoord;

  Map<String, dynamic> toMap() => {
    'id': id,
    'studentId': studentId,
    'questionId': questionId,
    'antwoord': antwoord,
  };

  @override
  String toString() {
    return 'Answer { id: $id, studentId: $studentId, questionId: $questionId, antwoord: $antwoord }';
  }
}