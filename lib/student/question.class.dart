class Question {
  late String id;
  late String oplossingen;
  late String type;
  late String vraag;
  late String studentId;
  late String antwoord;
  late List<String> antwoorden;

  Question({
    required this.id,
    required this.type,
    required this.vraag,
    antwoorden,
  });

  Map<String, dynamic> toJson() => {
        'antwoord': antwoord,
        'questionId': id,
        'studentId': studentId,
      };

  static Question fromJson(Map<String, dynamic> json) => Question(
      id: json['id'],
      type: json['type'],
      vraag: json['vraag'],
      antwoorden: json['antwoorden']);
}
