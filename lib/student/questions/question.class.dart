class Question {
  late String id;
  late String oplossingen;
  late String type;
  late String vraag;
  late String studentId;
  late String antwoord;
  late List<String> antwoorden = [];
  late bool beantwoord = false;

  Question({
    required this.id,
    required this.type,
    required this.vraag,
    required this.antwoorden,
  });

  Map<String, dynamic> toJsonOpen() => {
        'type': "open",
        'antwoord': antwoord,
        'questionId': id,
        'studentId': studentId,
      };

  Map<String, dynamic> toJsonMultiple() => {
        'type': "multiple",
        'antwoord': antwoord,
        'questionId': id,
        'studentId': studentId,
      };

  static Question fromJson(Map<String, dynamic> json) {
    if (json['antwoorden'] != null) {
      return Question(
          id: json['id'],
          type: json['type'],
          vraag: json['vraag'],
          antwoorden: List.from(json['antwoorden']));
    } else {
      return Question(
          id: json['id'],
          type: json['type'],
          vraag: json['vraag'],
          antwoorden: [""]);
    }
  }
}
