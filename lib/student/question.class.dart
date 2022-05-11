class Question {
  late List<dynamic> antwoorden;
  late String id;
  late String oplossingen;
  late String type;
  late String vraag;

  Question({
    required this.id,
    required this.type,
    required this.vraag,
  });

  Map<String, dynamic> toJson() => {
        'antwoorden': antwoorden,
        'id': id,
        'oplossingen': oplossingen,
        'type': type,
        'vraag': vraag,
      };

  static Question fromJson(Map<String, dynamic> json) =>
      Question(id: json['id'], type: json['type'], vraag: json['vraag']);
}
