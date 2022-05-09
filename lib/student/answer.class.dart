class Answer {
  late String id;
  late String studentId;
  late String questionId;
  late String answer;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'questionId': questionId,
      'answer': answer,
    };
  }
}
