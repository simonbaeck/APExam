class Question {
  late String id;
  late String oplossingen;
  late String type;
  late String vraag;
  late String studentId;
  late String antwoord;
  late List<String> antwoorden = [];

  Question({
    required this.id,
    required this.type,
    required this.vraag,
    required this.antwoorden,
  });

  Map<String, dynamic> toJson() => {
        'antwoord': antwoord,
        'questionId': id,
        'studentId': studentId,
      };

  static Question fromJson(Map<String, dynamic> json) {
    if (json['antwoorden'] != null) {
      print(json['antwoorden']);
      return Question(
          id: json['id'],
          type: json['type'],
          vraag: json['vraag'],
          antwoorden: List.from(json['antwoorden']));
    } else {
      print(json['antwoord']);
      return Question(
          id: json['id'],
          type: json['type'],
          vraag: json['vraag'],
          antwoorden: [""]);
    }
  }
}
